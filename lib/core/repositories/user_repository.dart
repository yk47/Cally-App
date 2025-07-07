import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class UserRepository {
  static const String _userKey = 'user_data';

  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      debugPrint('User saved successfully: ${user.name}');
    } catch (e) {
      debugPrint('Error saving user: ${e.toString()}');
      // For now, we'll just log the error but not throw
      // This prevents the registration flow from breaking
    }
  }

  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      if (userData != null) {
        final user = User.fromJson(jsonDecode(userData));
        debugPrint('User loaded successfully: ${user.name}');
        return user;
      }
      debugPrint('No user data found');
      return null;
    } catch (e) {
      debugPrint('Error loading user: ${e.toString()}');
      return null;
    }
  }

  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      debugPrint('User data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing user data: ${e.toString()}');
      // Re-throw the error so the UI can handle it
      throw Exception('Failed to clear user data: ${e.toString()}');
    }
  }
}
