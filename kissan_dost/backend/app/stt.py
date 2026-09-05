"""Local speech-to-text using faster-whisper on CPU."""

import os
import tempfile
from functools import lru_cache
from typing import Any

from fastapi import APIRouter, File, HTTPException, UploadFile, status
from fastapi.concurrency import run_in_threadpool
from pydantic import BaseModel

from app.core.logging import get_logger

logger = get_logger(__name__)

MODEL_SIZE = os.getenv("WHISPER_MODEL_SIZE", "small")
COMPUTE_TYPE = os.getenv("WHISPER_COMPUTE_TYPE", "int8")
CPU_THREADS = int(os.getenv("WHISPER_CPU_THREADS", "4"))

SUPPORTED_LANGUAGES = {"en", "ur"}
SUPPORTED_EXTENSIONS = {"wav", "mp3", "m4a", "mp4", "ogg", "webm", "flac", "aac"}
MAX_AUDIO_BYTES = 25 * 1024 * 1024


class LocalTranscriptionResponse(BaseModel):
    text: str
    # Detected spoken language, independent of the app's UI language.
    language: str
    duration_seconds: float
    model: str


class LocalSTTError(Exception):
    """Raised when local transcription fails."""


@lru_cache(maxsize=1)
def get_model() -> Any:
    from faster_whisper import WhisperModel

    logger.info(
        "Loading faster-whisper model=%s compute_type=%s threads=%s (cpu)",
        MODEL_SIZE,
        COMPUTE_TYPE,
        CPU_THREADS,
    )
    return WhisperModel(
        MODEL_SIZE,
        device="cpu",
        compute_type=COMPUTE_TYPE,
        cpu_threads=CPU_THREADS,
    )


def _detect_speech_language(model: Any, audio: Any) -> str:
    """Pick the spoken language from the languages the app supports.

    Unconstrained detection reports Urdu speech as Hindi (measured: hi=0.68 vs
    ur=0.29) and then emits Devanagari, so the choice is narrowed to en/ur.
    """
    _, _, all_probs = model.detect_language(audio=audio, vad_filter=True)
    probs = dict(all_probs)
    return max(SUPPORTED_LANGUAGES, key=lambda code: probs.get(code, 0.0))


def transcribe_path(audio_path: str) -> LocalTranscriptionResponse:
    try:
        from faster_whisper.audio import decode_audio

        model = get_model()
        audio = decode_audio(audio_path, sampling_rate=16000)
        language = _detect_speech_language(model, audio)

        segments, info = model.transcribe(
            audio,
            language=language,
            # Never "translate": the transcript stays in the spoken language.
            task="transcribe",
            beam_size=1,
            vad_filter=True,
        )
        text = "".join(segment.text for segment in segments).strip()
    except Exception as exc:
        logger.exception("Local transcription failed")
        raise LocalSTTError("Could not transcribe the audio.") from exc

    logger.info("Detected speech language=%s", language)

    return LocalTranscriptionResponse(
        text=text,
        language=info.language or language,
        duration_seconds=round(info.duration, 2),
        model=MODEL_SIZE,
    )


router = APIRouter(tags=["stt"])


@router.post("/stt/transcribe", response_model=LocalTranscriptionResponse)
async def transcribe_audio(
    audio: UploadFile = File(...),
) -> LocalTranscriptionResponse:
    if not audio.filename:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Audio filename is required.",
        )

    extension = audio.filename.rsplit(".", 1)[-1].lower()
    if extension not in SUPPORTED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unsupported audio format '{extension}'.",
        )

    audio_bytes = await audio.read()
    if not audio_bytes:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Audio file is empty.",
        )

    if len(audio_bytes) > MAX_AUDIO_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"Audio exceeds the {MAX_AUDIO_BYTES // (1024 * 1024)} MB limit.",
        )

    with tempfile.NamedTemporaryFile(suffix=f".{extension}", delete=True) as tmp:
        tmp.write(audio_bytes)
        tmp.flush()
        try:
            return await run_in_threadpool(transcribe_path, tmp.name)
        except LocalSTTError as exc:
            raise HTTPException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail=str(exc),
            ) from exc
