from fastapi import APIRouter, HTTPException, status

from app.schemas.assistant import AssistantRequest, AssistantResponse
from app.services.knowledge_service import StubKnowledgeService
from app.services.llm_service import HostedLLMService, LLMError
from app.services.stt_service import StubSpeechToTextService
from app.services.tts_service import StubTextToSpeechService

router = APIRouter(tags=["assistant"])

llm_service = HostedLLMService()
stt_service = StubSpeechToTextService()
tts_service = StubTextToSpeechService()
knowledge_service = StubKnowledgeService()


@router.post("/assistant", response_model=AssistantResponse)
async def assistant_endpoint(request: AssistantRequest) -> AssistantResponse:
    question = request.text

    if request.audio_base64:
        question = await stt_service.transcribe(
            request.audio_base64,
            language=request.farmer.language,
        )

    if not question:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="No question provided or audio could not be transcribed.",
        )

    knowledge = await knowledge_service.lookup(
        question=question,
        crop_ids=request.crop.crop_ids,
        location=request.farmer.location,
    )

    try:
        answer = await llm_service.generate_response(
            question=question,
            farmer=request.farmer,
            crop=request.crop,
            weather=request.weather,
            knowledge=knowledge,
            conversation_history=request.conversation_history,
            language=request.farmer.language,
        )
    except LLMError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=str(exc),
        ) from exc

    audio = await tts_service.synthesize(answer, language=request.farmer.language)

    return AssistantResponse(
        success=True,
        answer=answer,
        language=request.farmer.language,
        audio_base64=audio,
        asked_expert=False,
    )
