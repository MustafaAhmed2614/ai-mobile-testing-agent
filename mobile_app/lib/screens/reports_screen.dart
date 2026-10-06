import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'analysis_result_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await ApiService.getReports();

      if (!mounted) return;

      setState(() {
        reports = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> openReport(int reportId) async {
    try {
      final result =
          await ApiService.getReportDetail(reportId);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AnalysisResultScreen(
            result: result,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load report: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            onPressed: loadReports,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadReports,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return ListView(
        children: [
          const SizedBox(height: 120),
          const Icon(
            Icons.error_outline,
            size: 60,
          ),
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
              onPressed: loadReports,
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (reports.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Icon(
            Icons.history,
            size: 60,
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No reports available yet.',
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report =
            Map<String, dynamic>.from(
          reports[index],
        );

        final reportId = report['id'] as int;
        final issueCount =
            report['issue_count'] ?? 0;

        return Card(
          child: ListTile(
            onTap: () {
              openReport(reportId);
            },
            leading: CircleAvatar(
              child: Text(
                issueCount.toString(),
              ),
            ),
            title: Text(
              report['screen_type'] ??
                  'Unknown Screen',
            ),
            subtitle: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  report['framework'] ??
                      'Unknown framework',
                ),
                const SizedBox(height: 4),
                Text(
                  report['summary'] ??
                      'No summary available',
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: const Icon(
              Icons.chevron_right,
            ),
          ),
        );
      },
    );
  }
}