from typing import List, Optional


def build_system_prompt() -> str:
    return (
        "You are Kisan Dost, a helpful agricultural assistant for farmers. "
        "Answer farming questions in a simple, practical, and easy-to-understand way. "
        "Respond in the language the farmer asked the question. "
        "For Urdu users, write natural, conversational Urdu suitable for rural farmers. "
        "Use the farmer's name, location, and crop information when provided. "
        "Do not invent information you do not have. "
        "If you are uncertain or the situation could cause significant crop loss, "
        "advise the farmer to consult a qualified agricultural expert. "
        "Avoid unnecessary technical terminology. Keep answers short and actionable."
    )


def build_user_prompt(
    question: str,
    language: str,
    farmer_name: Optional[str],
    location: Optional[str],
    crop_ids: List[str],
    weather: Optional[dict],
) -> str:
    parts = [f"Language: {language}", f"Question: {question}"]

    if farmer_name:
        parts.append(f"Farmer name: {farmer_name}")
    if location:
        parts.append(f"Location: {location}")
    if crop_ids:
        parts.append(f"Selected crops: {', '.join(crop_ids)}")
    if weather:
        weather_text = ", ".join(f"{k}={v}" for k, v in weather.items() if v is not None)
        if weather_text:
            parts.append(f"Weather/context: {weather_text}")

    parts.append("Provide a clear, practical answer.")
    return "\n".join(parts)
