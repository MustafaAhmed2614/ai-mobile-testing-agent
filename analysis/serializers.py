from rest_framework import serializers


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