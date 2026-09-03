from typing import List, Optional

from pydantic import BaseModel, Field


class FarmerContext(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    language: str = "ur"


class CropContext(BaseModel):
    crop_ids: List[str] = Field(default_factory=list)
    current_stage: Optional[str] = None


class WeatherContext(BaseModel):
    temperature_c: Optional[float] = None
    condition: Optional[str] = None
    humidity_percent: Optional[int] = None
    rainfall_mm: Optional[float] = None


class AssistantRequest(BaseModel):
    audio_base64: Optional[str] = None
    text: Optional[str] = None
    farmer: FarmerContext = Field(default_factory=FarmerContext)
    crop: CropContext = Field(default_factory=CropContext)
    weather: WeatherContext = Field(default_factory=WeatherContext)
    conversation_history: List[dict] = Field(default_factory=list)


class AssistantResponse(BaseModel):
    success: bool
    answer: str
    language: str = "ur"
    audio_base64: Optional[str] = None
    asked_expert: bool = False


class HealthResponse(BaseModel):
    status: str
    version: str


class TranscriptionResponse(BaseModel):
    success: bool
    text: str
    language: str = "ur"
