import 'package:flutter/material.dart';

class AnalysisResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const AnalysisResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final issues = (result['issues'] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Result'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['screen_type'] ?? 'Unknown Screen',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result['summary'] ?? 'No summary available.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Issues found: ${result['issue_count'] ?? issues.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (issues.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No major issues detected.',
                ),
              ),
            ),

          ...issues.map((issue) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _IssueCard(
                issue: Map<String, dynamic>.from(issue),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final Map<String, dynamic> issue;

  const _IssueCard({
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    final confidence =
        ((issue['confidence'] ?? 0.0) as num).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    issue['title'] ?? 'Untitled Issue',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                _SeverityChip(
                  severity: issue['severity'] ?? 'low',
                ),
              ],
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    issue['category'] ?? 'other',
                  ),
                ),
                Chip(
                  label: Text(
                    'Confidence ${(confidence * 100).toStringAsFixed(0)}%',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              issue['description'] ??
                  'No description available.',
            ),

            const SizedBox(height: 12),

            const Text(
              'Evidence',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              issue['evidence'] ??
                  'No evidence provided.',
            ),

            const SizedBox(height: 12),

            const Text(
              'Suggested Fix',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              issue['suggested_fix'] ??
                  'No suggestion available.',
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final String severity;

  const _SeverityChip({
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (severity.toLowerCase()) {
      case 'high':
        icon = Icons.error_outline;
        break;
      case 'medium':
        icon = Icons.warning_amber_rounded;
        break;
      default:
        icon = Icons.info_outline;
    }

    return Chip(
      avatar: Icon(
        icon,
        size: 18,
      ),
      label: Text(
        severity.toUpperCase(),
      ),
    );
  }
}