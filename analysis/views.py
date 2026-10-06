from django.shortcuts import get_object_or_404

from rest_framework.decorators import api_view, parser_classes
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response

from .serializers import (
    ScreenshotUploadSerializer,
    AnalysisReportSerializer,
)
from .services.ai_service import analyze_screenshot
from .models import AnalysisReport, DetectedIssue


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

        report = AnalysisReport.objects.create(
            file_name=screenshot.name,
            framework=framework,
            screen_type=ai_result.get(
                "screen_type",
                "unknown"
            ),
            summary=ai_result.get(
                "summary",
                ""
            )
        )

        for issue in ai_result.get("issues", []):
            DetectedIssue.objects.create(
                report=report,
                title=issue.get(
                    "title",
                    "Untitled issue"
                ),
                category=issue.get(
                    "category",
                    "other"
                ),
                severity=issue.get(
                    "severity",
                    "low"
                ),
                confidence=issue.get(
                    "confidence",
                    0.0
                ),
                description=issue.get(
                    "description",
                    ""
                ),
                evidence=issue.get(
                    "evidence",
                    ""
                ),
                suggested_fix=issue.get(
                    "suggested_fix",
                    ""
                )
            )

        return Response({
            "message": "Screenshot analyzed successfully",
            "report_id": report.id,
            "file_name": screenshot.name,
            "framework": framework,
            "screen_type": ai_result.get(
                "screen_type",
                "unknown"
            ),
            "summary": ai_result.get(
                "summary",
                ""
            ),
            "issue_count": len(
                ai_result.get("issues", [])
            ),
            "issues": ai_result.get(
                "issues",
                []
            )
        })

    except Exception as error:
        return Response(
            {
                "error": "AI analysis failed",
                "details": str(error)
            },
            status=500
        )


@api_view(['GET'])
def report_list(request):
    reports = AnalysisReport.objects.all().order_by('-created_at')

    serializer = AnalysisReportSerializer(
        reports,
        many=True
    )

    return Response(serializer.data)

@api_view(['GET'])
def report_detail(request, report_id):
    report = get_object_or_404(
        AnalysisReport,
        id=report_id
    )

    serializer = AnalysisReportSerializer(report)

    return Response(serializer.data)