import base64

from fastapi import APIRouter, File, HTTPException, UploadFile, status

from app.schemas.assistant import TranscriptionResponse
from app.services.stt_service import HostedSpeechToTextService, STTError

router = APIRouter(tags=["speech"])

stt_service = HostedSpeechToTextService()


@router.post("/speech/transcribe", response_model=TranscriptionResponse)
async def transcribe_audio(
    audio: UploadFile = File(...),
    language: str = "ur",
) -> TranscriptionResponse:
    if not audio.filename:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Audio filename is required.",
        )

    extension = audio.filename.rsplit(".", 1)[-1].lower()
    if extension not in {"flac", "mp3", "mp4", "mpeg", "mpga", "m4a", "ogg", "wav", "webm"}:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Unsupported audio format: {extension}.",
        )

    try:
        audio_bytes = await audio.read()
    except Exception as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Could not read uploaded audio.",
        ) from exc

    if not audio_bytes:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Audio file is empty.",
        )

    audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")

    try:
        text = await stt_service.transcribe(audio_base64, language=language)
    except STTError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=str(exc),
        ) from exc

    if text is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Transcription failed.",
        )

    return TranscriptionResponse(
        success=True,
        text=text,
        language=language,
    )


@router.post("/speech/synthesize")
async def synthesize_speech() -> dict:
    raise HTTPException(
        status_code=status.HTTP_501_NOT_IMPLEMENTED,
        detail="Text-to-speech integration is not enabled yet.",
    )
