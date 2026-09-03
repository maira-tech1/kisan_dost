from abc import ABC, abstractmethod
from typing import List, Optional

import httpx

from app.core.config import get_settings
from app.core.logging import get_logger
from app.core.prompts import build_system_prompt, build_user_prompt
from app.schemas.assistant import CropContext, FarmerContext, WeatherContext

logger = get_logger(__name__)


class LLMService(ABC):
    @abstractmethod
    async def generate_response(
        self,
        question: str,
        farmer: FarmerContext,
        crop: CropContext,
        weather: WeatherContext,
        knowledge: Optional[str] = None,
        conversation_history: Optional[List[dict]] = None,
        language: str = "ur",
    ) -> str:
        """Generate a simple, practical agricultural response."""
        ...


class StubLLMService(LLMService):
    async def generate_response(
        self,
        question: str,
        farmer: FarmerContext,
        crop: CropContext,
        weather: WeatherContext,
        knowledge: Optional[str] = None,
        conversation_history: Optional[List[dict]] = None,
        language: str = "ur",
    ) -> str:
        return "یہ ایک عارضی جواب ہے۔ براہ کرم بعد میں دوبارہ کوشش کریں۔"


class HostedLLMService(LLMService):
    async def generate_response(
        self,
        question: str,
        farmer: FarmerContext,
        crop: CropContext,
        weather: WeatherContext,
        knowledge: Optional[str] = None,
        conversation_history: Optional[List[dict]] = None,
        language: str = "ur",
    ) -> str:
        settings = get_settings()
        if not settings.llm_api_key or settings.llm_api_key == "your_api_key_here":
            raise LLMError("LLM API key is not configured.")

        system_prompt = build_system_prompt()
        if knowledge:
            system_prompt += f"\n\nRelevant agricultural knowledge:\n{knowledge}"

        user_prompt = build_user_prompt(
            question=question,
            language=language,
            farmer_name=farmer.name,
            location=farmer.location,
            crop_ids=crop.crop_ids,
            weather=weather.model_dump() if weather else None,
        )

        messages = [{"role": "system", "content": system_prompt}]

        if conversation_history:
            messages.extend(conversation_history)

        messages.append({"role": "user", "content": user_prompt})

        payload = {
            "model": settings.llm_model,
            "messages": messages,
            "temperature": 0.5,
            "max_tokens": 512,
        }

        headers = {
            "Authorization": f"Bearer {settings.llm_api_key}",
            "Content-Type": "application/json",
        }

        try:
            async with httpx.AsyncClient(timeout=settings.llm_timeout_seconds) as client:
                response = await client.post(
                    f"{settings.llm_base_url}/chat/completions",
                    headers=headers,
                    json=payload,
                )
                response.raise_for_status()
                data = response.json()
                answer = data["choices"][0]["message"]["content"].strip()
                return answer
        except httpx.TimeoutException as exc:
            logger.error("LLM request timed out")
            raise LLMError("The model took too long to respond. Please try again.") from exc
        except httpx.HTTPStatusError as exc:
            response_body = exc.response.text
            logger.error(
                "LLM provider error: status=%s body=%s",
                exc.response.status_code,
                response_body,
            )
            if exc.response.status_code == 401:
                raise LLMError("Invalid LLM API key.") from exc
            if exc.response.status_code == 429:
                raise LLMError("Rate limit reached. Please wait a moment and try again.") from exc
            raise LLMError("The LLM provider returned an error.") from exc
        except httpx.RequestError as exc:
            logger.error("LLM provider unavailable: %s", exc)
            raise LLMError("The LLM provider is unavailable.") from exc
        except (KeyError, IndexError, AttributeError) as exc:
            logger.error("Unexpected LLM response format: %s", exc)
            raise LLMError("Received an unexpected response from the LLM provider.") from exc
        except Exception as exc:
            logger.exception("Unexpected error while calling LLM")
            raise LLMError("An unexpected error occurred while generating the response.") from exc


class LLMError(Exception):
    """Raised when the LLM service fails to generate a response."""
