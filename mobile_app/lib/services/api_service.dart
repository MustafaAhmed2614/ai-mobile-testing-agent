import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> analyzeScreenshot({
    required String imagePath,
    required String framework,
  }) async {
    final uri = Uri.parse('$baseUrl/api/analyze-ui/');

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['framework'] = framework;

    request.files.add(
      await http.MultipartFile.fromPath(
        'screenshot',
        imagePath,
      ),
    );

    final streamedResponse = await request.send();

    final responseBody =
        await streamedResponse.stream.bytesToString();

    final decoded = jsonDecode(responseBody);

    if (streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300) {
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception(
      decoded['details'] ??
          decoded['error'] ??
          'Request failed',
    );
  }

  static Future<List<dynamic>> getReports() async {
    final uri = Uri.parse('$baseUrl/api/reports/');

    final response = await http.get(uri);

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return decoded as List<dynamic>;
    }

    throw Exception(
      'Failed to load reports',
    );
  }

  static Future<Map<String, dynamic>> getReportDetail(
    int reportId,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/api/reports/$reportId/',
    );

    final response = await http.get(uri);

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception(
      'Failed to load report details',
    );
  }
}