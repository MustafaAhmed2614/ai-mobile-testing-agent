import base64
import json
import requests


OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
OLLAMA_MODEL = "gemma3:4b"


def extract_json(text):
    text = text.strip()

    if text.startswith("```"):
        text = text.replace("```json", "").replace("```", "").strip()

    start = text.find("{")
    end = text.rfind("}")

    if start == -1 or end == -1:
        raise ValueError(
            f"Could not find valid JSON in model response: {text}"
        )

    json_text = text[start:end + 1]

    return json.loads(json_text)


def analyze_screenshot(screenshot, framework):
    image_bytes = screenshot.read()

    base64_image = base64.b64encode(
        image_bytes
    ).decode("utf-8")

    prompt = f"""
You are a senior mobile application QA engineer.

Analyze this {framework} mobile application screenshot carefully.

Your job is to identify only issues that are reasonably visible from the screenshot.

Check for:
- UI overflow
- alignment issues
- spacing inconsistencies
- poor visual hierarchy
- typography issues
- accessibility concerns
- touch target concerns
- usability problems
- responsive layout issues

Important rules:
- Do not invent bugs.
- Do not claim exact measurements unless clearly visible or known.
- If an issue is uncertain, use a lower confidence score.
- Distinguish between confirmed visual issues and possible concerns.
- Keep suggested fixes specific to the selected framework: {framework}.
- Return ONLY valid JSON.
- Do not include markdown.
- Do not include explanations outside the JSON.

Return this exact JSON structure:

{{
  "screen_type": "string",
  "summary": "short overall assessment of the screen",
  "issues": [
    {{
      "title": "string",
      "category": "layout | spacing | typography | accessibility | usability | responsive | visual_hierarchy | other",
      "severity": "low | medium | high",
      "confidence": 0.0,
      "description": "string",
      "evidence": "what in the screenshot led to this finding",
      "suggested_fix": "specific fix suggestion"
    }}
  ]
}}

Confidence must be a number between 0.0 and 1.0.

If no meaningful issues are visible, return:

{{
  "screen_type": "string",
  "summary": "No significant visual issues detected.",
  "issues": []
}}
"""

    payload = {
        "model": OLLAMA_MODEL,
        "prompt": prompt,
        "images": [base64_image],
        "stream": False,
        "options": {
            "temperature": 0.2
        }
    }

    try:
        response = requests.post(
            OLLAMA_URL,
            json=payload,
            timeout=120
        )

        response.raise_for_status()

    except requests.exceptions.ConnectionError:
        raise RuntimeError(
            "Could not connect to Ollama. Make sure 'ollama serve' is running."
        )

    except requests.exceptions.Timeout:
        raise RuntimeError(
            "Ollama took too long to analyze the screenshot."
        )

    result = response.json()

    raw_output = result.get("response", "")

    if not raw_output:
        raise ValueError(
            "Ollama returned an empty response."
        )

    ai_result = extract_json(raw_output)

    if "screen_type" not in ai_result:
        ai_result["screen_type"] = "unknown"

    if "summary" not in ai_result:
        ai_result["summary"] = ""

    if "issues" not in ai_result:
        ai_result["issues"] = []

    return ai_result