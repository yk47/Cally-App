import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CallListRepository {
  final String baseUrl = 'https://mock-api.calleyacd.com/api/list';

  Future<Map<String, dynamic>> getCallList(String listId) async {
    try {
      debugPrint('Fetching call list data for ID: $listId');
      final response = await http.get(
        Uri.parse('$baseUrl/$listId'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Call list API status: ${response.statusCode}');
      debugPrint('Call list API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final pending = data['pending'] ?? 0;
        final done = data['called'] ?? 0;
        final schedule = data['rescheduled'] ?? 0;
        final total = pending + done + schedule;

        debugPrint(
          'Call statistics - Pending: $pending, Done: $done, Schedule: $schedule, Total: $total',
        );

        return {
          'pending': pending,
          'done': done,
          'schedule': schedule,
          'total': total,
          'calls': data['calls'] ?? [],
        };
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Failed to fetch call list';
        debugPrint('Call list API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Call list exception: ${e.toString()}');
      throw Exception('Failed to fetch call list: ${e.toString()}');
    }
  }
}
