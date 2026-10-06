from rest_framework.decorators import api_view, parser_classes
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response

from .serializers import ScreenshotUploadSerializer
from .services.ai_service import analyze_screenshot


@api_view(['POST'])
@parser_classes([MultiPartParser, FormParser])
def analyze_ui(request):
    serializer = ScreenshotUploadSerializer(data=request.data)

    if not serializer.is_valid():
        return Response(serializer.errors, status=400)

    screenshot = serializer.validated_data['screenshot']
    framework = serializer.validated_data['framework']

    try:
        ai_result = analyze_screenshot(
            screenshot=screenshot,
            framework=framework
        )

        return Response({
    "message": "Screenshot analyzed successfully",
    "file_name": screenshot.name,
    "framework": framework,
    "screen_type": ai_result.get("screen_type", "unknown"),
    "summary": ai_result.get("summary", ""),
    "issue_count": len(ai_result.get("issues", [])),
    "issues": ai_result.get("issues", [])
})

    except Exception as error:
        return Response(
            {
                "error": "AI analysis failed",
                "details": str(error)
            },
            status=500
        )