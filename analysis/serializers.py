from rest_framework import serializers
from .models import AnalysisReport, DetectedIssue


class ScreenshotUploadSerializer(serializers.Serializer):
    FRAMEWORK_CHOICES = [
        ('flutter', 'Flutter'),
        ('ios', 'iOS'),
        ('android', 'Android'),
    ]

    screenshot = serializers.ImageField(required=True)
    framework = serializers.ChoiceField(
        choices=FRAMEWORK_CHOICES,
        required=False,
        default='flutter'
    )


class DetectedIssueSerializer(serializers.ModelSerializer):
    class Meta:
        model = DetectedIssue
        fields = [
            'id',
            'title',
            'category',
            'severity',
            'confidence',
            'description',
            'evidence',
            'suggested_fix',
        ]


class AnalysisReportSerializer(serializers.ModelSerializer):
    issues = DetectedIssueSerializer(
        many=True,
        read_only=True
    )

    issue_count = serializers.SerializerMethodField()

    class Meta:
        model = AnalysisReport
        fields = [
            'id',
            'file_name',
            'framework',
            'screen_type',
            'summary',
            'issue_count',
            'issues',
            'created_at',
        ]

    def get_issue_count(self, obj):
        return obj.issues.count()