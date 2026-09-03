from abc import ABC, abstractmethod
from typing import Optional


class TextToSpeechService(ABC):
    @abstractmethod
    async def synthesize(self, text: str, language: str = "ur") -> Optional[str]:
        """Convert text into base64-encoded audio."""
        ...


class StubTextToSpeechService(TextToSpeechService):
    async def synthesize(self, text: str, language: str = "ur") -> Optional[str]:
        return None
