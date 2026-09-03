from fastapi import APIRouter, HTTPException, status

from app.schemas.assistant import WeatherContext
from app.services.weather_service import StubWeatherService

router = APIRouter(tags=["weather"])
weather_service = StubWeatherService()


@router.get("/weather", response_model=WeatherContext)
async def get_weather(location: str) -> WeatherContext:
    weather = await weather_service.fetch(location)
    if weather is None:
        raise HTTPException(
            status_code=status.HTTP_501_NOT_IMPLEMENTED,
            detail="Weather integration is not enabled yet.",
        )
    return weather
