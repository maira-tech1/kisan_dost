from fastapi import APIRouter

from app.api.routes import assistant, health, speech, weather

api_router = APIRouter()

api_router.include_router(health.router)
api_router.include_router(assistant.router)
api_router.include_router(speech.router)
api_router.include_router(weather.router)
