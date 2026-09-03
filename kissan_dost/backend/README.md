# Kisan Dost Backend

FastAPI backend for the Kisan Dost agricultural voice assistant.

## Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
```

## Run

```bash
uvicorn app.main:app --reload
```

The API is available at `http://localhost:8000`.

## API

- `GET /api/v1/health` — Health check
- `POST /api/v1/assistant` — Voice/text assistant request
- `GET /api/v1/weather?location=...` — Weather lookup (stub)
- `POST /api/v1/speech/transcribe` — STT (stub)
- `POST /api/v1/speech/synthesize` — TTS (stub)
- `/docs` — OpenAPI documentation

## Architecture

- `app/core/` — Configuration, logging, shared utilities
- `app/api/` — API routes and versioning
- `app/schemas/` — Pydantic request/response models
- `app/services/` — Service interfaces for STT, LLM, TTS, weather, and knowledge

Services are currently stub implementations to keep provider integrations out of the foundation.
