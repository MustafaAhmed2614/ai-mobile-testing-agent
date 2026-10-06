from django.urls import path
from .views import analyze_ui, report_list, report_detail

urlpatterns = [
    path(
        'analyze-ui/',
        analyze_ui,
        name='analyze-ui'
    ),
    path(
        'reports/',
        report_list,
        name='report-list'
    ),

    path(
        'reports/<int:report_id>/',
        report_detail,
        name='report-detail'
    ),
]