from abc import ABC, abstractmethod
from typing import Optional

from app.schemas.assistant import WeatherContext


class WeatherService(ABC):
    @abstractmethod
    async def fetch(self, location: str) -> Optional[WeatherContext]:
        """Fetch current weather for a location."""
        ...


class StubWeatherService(WeatherService):
    async def fetch(self, location: str) -> Optional[WeatherContext]:
        return None
