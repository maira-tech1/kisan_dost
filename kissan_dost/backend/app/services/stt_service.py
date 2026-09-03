import base64
import io
from abc import ABC, abstractmethod
from typing import Optional

import httpx

from app.core.config import get_settings
from app.core.logging import get_logger

logger = get_logger(__name__)

SUPPORTED_AUDIO_EXTENSIONS = {
    "flac",
    "mp3",
    "mp4",
    "mpeg",
    "mpga",
    "m4a",
    "ogg",
    "wav",
    "webm",
}


class SpeechToTextService(ABC):
    @abstractmethod
    async def transcribe(self, audio_base64: str, language: str = "ur") -> Optional[str]:
        """Convert base64-encoded audio into text."""
        ...


class StubSpeechToTextService(SpeechToTextService):
    async def transcribe(self, audio_base64: str, language: str = "ur") -> Optional[str]:
        return None


class HostedSpeechToTextService(SpeechToTextService):
    async def transcribe(self, audio_base64: str, language: str = "ur") -> Optional[str]:
        settings = get_settings()
        if not settings.stt_api_key or settings.stt_api_key == "your_api_key_here":
            raise STTError("STT API key is not configured.")

        try:
            audio_bytes = base64.b64decode(audio_base64, validate=True)
        except Exception as exc:
            raise STTError("Invalid audio data.") from exc

        if not audio_bytes:
            raise STTError("Audio file is empty.")

        max_size_bytes = settings.stt_max_audio_size_mb * 1024 * 1024
        if len(audio_bytes) > max_size_bytes:
            raise STTError(
                f"Audio file exceeds maximum size of {settings.stt_max_audio_size_mb} MB."
            )

        try:
            async with httpx.AsyncClient(timeout=settings.stt_timeout_seconds) as client:
                files = {
                    "file": ("audio.webm", io.BytesIO(audio_bytes), "audio/webm"),
                }
                data = {
                    "model": settings.stt_model,
                    "language": language,
                    "response_format": "json",
                }
                headers = {
                    "Authorization": f"Bearer {settings.stt_api_key}",
                }

                response = await client.post(
                    f"{settings.stt_base_url}/audio/transcriptions",
                    headers=headers,
                    files=files,
                    data=data,
                )
                response.raise_for_status()
                result = response.json()
                text = result.get("text")
                if not text:
                    raise STTError("The STT provider returned an empty transcription.")
                return text
        except httpx.TimeoutException as exc:
            logger.error("STT request timed out")
            raise STTError("The STT provider took too long to respond.") from exc
        except httpx.HTTPStatusError as exc:
            response_body = exc.response.text
            logger.error(
                "STT provider error: status=%s body=%s",
                exc.response.status_code,
                response_body,
            )
            if exc.response.status_code == 401:
                raise STTError("Invalid STT API key.") from exc
            if exc.response.status_code == 429:
                raise STTError("STT rate limit reached. Please try again later.") from exc
            if exc.response.status_code == 400:
                raise STTError("Unsupported or invalid audio format.") from exc
            raise STTError("The STT provider returned an error.") from exc
        except httpx.RequestError as exc:
            logger.error("STT provider unavailable: %s", exc)
            raise STTError("The STT provider is unavailable.") from exc
        except (KeyError, ValueError) as exc:
            logger.error("Unexpected STT response format: %s", exc)
            raise STTError("Received an unexpected response from the STT provider.") from exc
        except Exception as exc:
            logger.exception("Unexpected error while calling STT")
            raise STTError("An unexpected error occurred during transcription.") from exc


class STTError(Exception):
    """Raised when the STT service fails to transcribe audio."""
