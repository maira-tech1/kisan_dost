# Kisan Dost AI Architecture

## AI Pipeline

The assistant follows:

Voice
→ Speech-to-Text
→ Question
→ Farmer Context
→ Crop Context
→ Weather Context
→ Agricultural Knowledge
→ LLM
→ Urdu Response
→ Text-to-Speech

---

# AI Independence

The application should not be tightly coupled to a specific
LLM provider.

The model can be replaced without changing the Flutter
presentation layer.

---

# Agricultural Knowledge

The LLM should not be the only source of agricultural information.

Use curated agricultural knowledge and simple rules where
appropriate.

Potential knowledge categories:

- Crop information
- Irrigation
- Fertilization
- Pests
- Diseases
- Symptoms
- Weather-related recommendations
- Basic farming practices

---

# Response Philosophy

Responses should be:

- Simple
- Practical
- Short
- In Urdu
- Easy for farmers to understand

Avoid unnecessary technical terminology.

---

# Safety

Kisan Dost provides guidance, not guaranteed diagnoses.

When the system is uncertain or the situation could cause
significant crop loss, the response should encourage consultation
with a qualified agricultural expert.

The AI should not invent highly specific recommendations when
the required information is unavailable.

---

# Context

Where available, AI requests should include:

- Farmer profile
- Crop
- Location
- Weather
- Relevant agricultural knowledge
- Previous conversation context

Only include information relevant to the current question.