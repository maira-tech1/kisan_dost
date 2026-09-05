# Kisan Dost Backend

FastAPI backend for the Kisan Dost agricultural voice assistant.

## Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
```

## Run

```bash
uvicorn app.main:app --reload
```

The API is available at `http://localhost:8000`.

To let an Android device reach the server over the local network, bind to all
interfaces and use the Mac's LAN IP from the app:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

## API

- `GET /api/v1/health` — Health check
- `POST /api/v1/stt/transcribe` — Local speech-to-text (faster-whisper, CPU)
- `POST /api/v1/assistant` — Voice/text assistant request
- `GET /api/v1/weather?location=...` — Weather lookup (stub)
- `POST /api/v1/speech/transcribe` — STT via hosted provider (requires `STT_API_KEY`)
- `POST /api/v1/speech/synthesize` — TTS (stub)
- `/docs` — OpenAPI documentation

## Local speech-to-text

`app/stt.py` runs [faster-whisper](https://github.com/SYSTRAN/faster-whisper)
directly on the machine hosting the API — no external speech API and no API key.
It uses the multilingual `small` model with `int8` CPU inference, which balances
Urdu/English accuracy against speed on a Mac development machine.

The model is downloaded from Hugging Face on the first transcription request
(~500 MB, cached in `~/.cache/huggingface`) and kept in memory afterwards, so
the first call is slower than subsequent ones.

Override the defaults with environment variables if needed:

| Variable                | Default | Notes                                        |
| ----------------------- | ------- | -------------------------------------------- |
| `WHISPER_MODEL_SIZE`    | `small` | e.g. `base` for more speed, `medium` for accuracy |
| `WHISPER_COMPUTE_TYPE`  | `int8`  | `float32` is slower but slightly more accurate |
| `WHISPER_CPU_THREADS`   | `4`     | Inference threads                            |

### Request

`POST /api/v1/stt/transcribe` — `multipart/form-data`

| Field      | Type   | Notes                                     |
| ---------- | ------ | ----------------------------------------- |
| `audio`    | file   | Required. wav, mp3, m4a, mp4, ogg, webm, flac, aac. Max 25 MB. |

The spoken language is detected from the audio, so callers do not send it. The
detection is restricted to `en` and `ur`, because unconstrained Whisper reports
Urdu speech as Hindi and returns Devanagari script. `task="transcribe"` is always
used, so a transcript is never translated into the other language.

```bash
curl -X POST http://localhost:8000/api/v1/stt/transcribe \
  -F "audio=@sample.wav"
```

### Response

`language` is the **detected speech language**, not the app's UI language.

```json
{
  "text": "گندم کے پتے پیلے کیوں ہو رہے ہیں؟",
  "language": "ur",
  "duration_seconds": 3.42,
  "model": "small"
}
```

Errors return a JSON `detail` message: `400` for a missing/empty file or an
unsupported format, `413` when the upload exceeds the
size limit, and `422` when the audio cannot be transcribed.

## Architecture

- `app/core/` — Configuration, logging, shared utilities
- `app/api/` — API routes and versioning
- `app/schemas/` — Pydantic request/response models
- `app/services/` — Service interfaces for STT, LLM, TTS, weather, and knowledge
- `app/stt.py` — Local faster-whisper speech-to-text (CPU) and its route

Apart from local STT, services are currently stub implementations to keep
provider integrations out of the foundation.
