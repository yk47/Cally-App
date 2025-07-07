import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/models/user_model.dart';

class AuthRepository {
  final String baseUrl = 'https://mock-api.calleyacd.com/api/auth';

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    debugPrint('Register API status: ${response.statusCode}');
    debugPrint('Register API response: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // Create user object with the registration data
      final user = User(
        id:
            data['user']?['id']?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: username,
        email: email,
        phone: null,
      );

      debugPrint('Created user object: ${user.name}, ${user.email}');

      return {'message': data['message'] ?? 'Registered', 'user': user};
    } else {
      debugPrint('Register API error: ${response.body}');
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Registration failed',
      );
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Attempting login API call for: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('Login API status: ${response.statusCode}');
      debugPrint('Login API response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Create user object from API response
        final userdata = data['user'];
        final user = User(
          id: userdata['_id'] ?? '',
          name: userdata['username'] ?? '',
          email: userdata['email'] ?? email,
        );

        debugPrint('User object created: ${user.name}, ${user.email}');

        return {'message': data['message'] ?? 'Login successful', 'user': user};
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Login failed';
        debugPrint('Login API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Login exception: ${e.toString()}');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<String> sendOtp({required String email}) async {
    try {
      debugPrint('Attempting to send OTP to: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      debugPrint('Send OTP API status: ${response.statusCode}');
      debugPrint('Send OTP API response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final message = data['message'] ?? 'OTP sent successfully';
        debugPrint('OTP send success: $message');
        return message;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Failed to send OTP';
        debugPrint('Send OTP API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Send OTP exception: ${e.toString()}');
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<String> verifyOtp({required String email, required String otp}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'OTP verified';
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'OTP verification failed',
      );
    }
  }
}
