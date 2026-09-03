from abc import ABC, abstractmethod
from typing import List, Optional


class KnowledgeService(ABC):
    @abstractmethod
    async def lookup(
        self,
        question: str,
        crop_ids: List[str],
        location: Optional[str] = None,
    ) -> Optional[str]:
        """Return curated agricultural knowledge relevant to the question."""
        ...


class StubKnowledgeService(KnowledgeService):
    async def lookup(
        self,
        question: str,
        crop_ids: List[str],
        location: Optional[str] = None,
    ) -> Optional[str]:
        return None
