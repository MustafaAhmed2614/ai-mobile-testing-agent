# AI Mobile Testing Agent

AI-powered mobile UI testing tool that analyzes application screenshots, identifies possible UI/UX issues, and generates structured QA reports using a locally running vision model.

## Features

- Screenshot-based UI analysis
- Flutter, iOS, and Android framework selection
- Local AI inference using Ollama + Gemma 3
- Detects spacing, typography, usability, accessibility, and layout concerns
- Confidence scores for detected issues
- Evidence and suggested fixes
- Saved analysis history
- Report detail API
- Flutter mobile frontend
- Django REST backend

## Tech Stack

### Mobile
- Flutter
- Dart
- HTTP
- Image Picker

### Backend
- Django
- Django REST Framework
- SQLite

### AI
- Ollama
- Gemma 3 Vision
- Local multimodal inference

## Architecture

Flutter App  
↓  
Django REST API  
↓  
Ollama  
↓  
Gemma 3 Vision  
↓  
Structured JSON QA Report  
↓  
Database  

## API Endpoints

### Analyze Screenshot

POST `/api/analyze-ui/`

### Reports

GET `/api/reports/`

### Report Detail

GET `/api/reports/<id>/`

## Running Locally

### 1. Start Ollama

```bash
ollama serve


2. Pull the model
ollama pull gemma3:4b

3. Start Django Backend
source venv/bin/activate
python manage.py runserver

4. Start Flutter App
cd mobile_app
flutter pub get
flutter run

Example AI Output
{
  "screen_type": "Mobile App Screen",
  "issue_count": 3,
  "issues": [
    {
      "title": "Spacing inconsistency",
      "category": "spacing",
      "severity": "low",
      "confidence": 0.7,
      "evidence": "Session cards show inconsistent vertical spacing.",
      "suggested_fix": "Use consistent padding values."
    }
  ]
}



Project Goal
The goal is to explore multimodal AI and mobile software testing by combining Flutter, Django REST APIs, local vision models, and QA automation concepts.
Future Improvements
- Automated app navigation
- Appium/ADB integration
- Automated tap and swipe actions
- Source code analysis
- Accessibility scoring
- Screenshot comparison
- Authentication
- PostgreSQL