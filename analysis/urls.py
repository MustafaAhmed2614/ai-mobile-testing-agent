from django.urls import path
from .views import analyze_ui

urlpatterns = [
    path('analyze-ui/', analyze_ui, name='analyze-ui'),
]