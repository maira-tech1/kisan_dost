from functools import lru_cache
from typing import List

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
        env_expand_vars=True,
    )

    app_name: str = "Kisan Dost API"
    app_version: str = "1.0.0"
    debug: bool = False

    host: str = "0.0.0.0"
    port: int = 8000
    api_prefix: str = "/api/v1"

    cors_origins: List[str] = ["*"]

    default_language: str = "ur"
    fallback_language: str = "en"

    max_audio_size_mb: int = 10
    request_timeout_seconds: int = 30

    llm_api_key: str = ""
    llm_base_url: str = "https://api.groq.com/openai/v1"
    llm_model: str = "qwen-2.5-32b-instruct"
    llm_timeout_seconds: int = 30

    stt_api_key: str = ""
    stt_base_url: str = "https://api.groq.com/openai/v1"
    stt_model: str = "whisper-large-v3-turbo"
    stt_timeout_seconds: int = 30
    stt_max_audio_size_mb: int = 25


@lru_cache
def get_settings() -> Settings:
    return Settings()
