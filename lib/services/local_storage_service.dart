import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const String _profileImageKey = "profile_image";
  static const String _usersKey = 'app_users';
  static const String _currentUserKey = 'current_user';

  // حفظ مستخدم جديد
  // في عملية التسجيل
  static Future<bool> registerUser(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();

      // التحقق إذا الإيميل موجود مسبقاً
      if (users.any((user) => user['email'] == userData['email'])) {
        return false;
      }

      // إضافة ID فريد للمستخدم
      userData['id'] = DateTime.now().millisecondsSinceEpoch.toString();

      users.add(userData);
      await prefs.setString(_usersKey, json.encode(users));
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  // تسجيل الدخول
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final users = await getUsers();

      final user = users.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == password,
      );

      if (user != null && user.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, json.encode(user));
        return user;
      }

      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  // جلب جميع المستخدمين
  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString(_usersKey);
      if (usersString != null) {
        final List<dynamic> usersList = json.decode(usersString);
        return usersList.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  // جلب المستخدم الحالي
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_currentUserKey);
      if (userString != null) {
        return Map<String, dynamic>.from(json.decode(userString));
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // تحديث بيانات المستخدم
  static Future<bool> updateUser(Map<String, dynamic> updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final users = await getUsers();

      final index = users.indexWhere(
        (user) => user['email'] == updatedUser['email'],
      );

      if (index != -1) {
        users[index] = updatedUser;
        await prefs.setString(_usersKey, json.encode(users));

        // تحديث المستخدم الحالي إذا كان هو نفسه
        final currentUser = await getCurrentUser();
        if (currentUser != null &&
            currentUser['email'] == updatedUser['email']) {
          await prefs.setString(_currentUserKey, json.encode(updatedUser));
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // حفظ رابط الصورة
  Future<void> saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, url);
  }

  // جلب رابط الصورة
  Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  /// مسح بيانات المستخدم الحالي
  static Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// حذف مستخدم من التخزين
  static Future<void> deleteUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> users = await getUsers();

    users.removeWhere((user) => user["email"] == email);

    await prefs.setString(_usersKey, jsonEncode(users));

    // لو المحذوف هو المستخدم الحالي، امسحه كمان
    final currentUser = await getCurrentUser();
    if (currentUser != null && currentUser["email"] == email) {
      await clearCurrentUser();
    }
  }
}
