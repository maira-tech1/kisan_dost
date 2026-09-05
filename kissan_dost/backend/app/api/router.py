from fastapi import APIRouter

from app.api.routes import assistant, health, speech, weather
from app.stt import router as stt_router

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(assistant.router)
api_router.include_router(speech.router)
api_router.include_router(weather.router)
api_router.include_router(stt_router)
