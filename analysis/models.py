from django.db import models


class AnalysisReport(models.Model):
    FRAMEWORK_CHOICES = [
        ('flutter', 'Flutter'),
        ('ios', 'iOS'),
        ('android', 'Android'),
    ]

    file_name = models.CharField(max_length=255)
    framework = models.CharField(
        max_length=20,
        choices=FRAMEWORK_CHOICES
    )
    screen_type = models.CharField(
        max_length=100,
        blank=True
    )
    summary = models.TextField(
        blank=True
    )
    created_at = models.DateTimeField(
        auto_now_add=True
    )

    def __str__(self):
        return f"{self.file_name} - {self.framework}"


class DetectedIssue(models.Model):
    SEVERITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
    ]

    report = models.ForeignKey(
        AnalysisReport,
        on_delete=models.CASCADE,
        related_name='issues'
    )

    title = models.CharField(max_length=255)
    category = models.CharField(max_length=100)
    severity = models.CharField(
        max_length=20,
        choices=SEVERITY_CHOICES
    )
    confidence = models.FloatField(default=0.0)
    description = models.TextField()
    evidence = models.TextField(blank=True)
    suggested_fix = models.TextField()

    def __str__(self):
        return self.title