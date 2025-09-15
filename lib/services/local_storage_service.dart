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
      // جلب المستخدمين الحاليين
      final usersString = prefs.getString(_usersKey);
      List<Map<String, dynamic>> users = [];
      if (usersString != null && usersString.isNotEmpty) {
        // تحويل البيانات من JSON إلى List<Map>
        final List<dynamic> decodedUsers = json.decode(usersString);
        users = decodedUsers.cast<Map<String, dynamic>>();
      }
      // التحقق إذا الإيميل موجود مسبقاً
      if (users.any((user) => user['email'] == userData['email'])) {
        return false;
      }
      // إضافة ID فريد للمستخدم
      userData['id'] = DateTime.now().millisecondsSinceEpoch.toString();

      // إضافة المستخدم الجديد إلى القائمة
      users.add(userData);

      // حفظ القائمة المحدثة
      await prefs.setString(_usersKey, json.encode(users));

      // حفظ المستخدم كحالي مباشرة بعد التسجيل
      await prefs.setString(_currentUserKey, json.encode(userData));

      return true;
    } catch (e) {
      print('خطأ في حفظ المستخدم: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final users = await getUsers();
      print('عدد المستخدمين المسجلين: ${users.length}');

      // طباعة تفصيلية لجميع المستخدمين
      for (var user in users) {
        print(
          'مستخدم: ${user['email']} - كلمة المرور: ${user['password'] ?? "NULL"} - جميع البيانات: $user',
        );
      }

      final user = users.firstWhereOrNull(
        (u) => u['email'] == email && u['password'] == password,
      );

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, json.encode(user));
        print('تم تسجيل الدخول بنجاح: $email');
        return user;
      }

      print('فشل تسجيل الدخول: $email - كلمة المرور المدخلة: $password');
      return null;
    } catch (e) {
      print('خطأ في تسجيل الدخول: $e');
      return null;
    }
  }

  // جلب جميع المستخدمين
  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString(_usersKey);

      if (usersString != null && usersString.isNotEmpty) {
        final List<dynamic> usersList = json.decode(usersString);
        return usersList
            .map((user) => Map<String, dynamic>.from(user))
            .toList();
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

  //تسجيل الخروج
  static Future<void> logout() async {
    final currentUser = await getCurrentUser();
    final userEmail = currentUser?['email'];

    if (userEmail != null) {
      // مسح جميع بيانات هذا المستخدم بما فيها التنبيهات
      await _clearAllUserData(userEmail);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    print('تم تسجيل الخروج ومسح بيانات المستخدم');
  }

  /// مسح جميع بيانات مستخدم معين
  static Future<void> _clearAllUserData(String email) async {
    final prefs = await SharedPreferences.getInstance();

    // الحصول على جميع المفاتيح
    final allKeys = prefs.getKeys();

    // مسح المفاتيح الخاصة بهذا المستخدم فقط
    for (final key in allKeys) {
      if (key.contains('user_${email}_') ||
          key.contains('notifications_$email')) {
        await prefs.remove(key);
        print('تم مسح المفتاح: $key');
      }
    }

    print('تم مسح جميع بيانات المستخدم: $email');
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
        // 🔥 دمج البيانات القديمة مع الجديدة (الحفاظ على كلمة المرور)
        users[index] = {
          ...users[index], // البيانات القديمة
          ...updatedUser, // البيانات الجديدة
        };

        await prefs.setString(_usersKey, json.encode(users));

        // تحديث المستخدم الحالي إذا كان هو نفسه
        final currentUser = await getCurrentUser();
        if (currentUser != null &&
            currentUser['email'] == updatedUser['email']) {
          await prefs.setString(_currentUserKey, json.encode(users[index]));
        }

        return true;
      }
      return false;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // التحقق من صحة بيانات المستخدمين
  static Future<void> debugAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString(_usersKey);

      print('=== 🔍 تحليل بيانات جميع المستخدمين ===');

      if (usersString != null && usersString.isNotEmpty) {
        final List<dynamic> usersList = json.decode(usersString);
        final users = usersList.cast<Map<String, dynamic>>();

        for (var i = 0; i < users.length; i++) {
          final user = users[i];
          print('👤 المستخدم #${i + 1}:');
          print('   📧 البريد: ${user['email']}');
          print('   🔐 كلمة المرور: ${user['password'] ?? 'NULL'}');
          print('   📝 يحتوي على password: ${user.containsKey('password')}');
          print('   🆔 ID: ${user['id']}');
          print('   📛 الاسم: ${user['username']}');
          print('   ---');
        }
      } else {
        print('📭 لا يوجد مستخدمين مسجلين');
      }
    } catch (e) {
      print('❌ خطأ في تحليل البيانات: $e');
    }
  }

  // التحقق من المستخدم الحالي
  static Future<void> debugCurrentUser() async {
    try {
      final currentUser = await getCurrentUser();

      print('=== 🔍 تحليل المستخدم الحالي ===');
      if (currentUser != null) {
        print('📧 البريد: ${currentUser['email']}');
        print('🔐 كلمة المرور: ${currentUser['password'] ?? 'NULL'}');
        print('📝 يحتوي على password: ${currentUser.containsKey('password')}');
        print('📦 جميع البيانات: $currentUser');
      } else {
        print('📭 لا يوجد مستخدم حالي');
      }
    } catch (e) {
      print('❌ خطأ في تحليل المستخدم الحالي: $e');
    }
  }

  // حفظ رابط الصورة
  Future<void> saveProfileImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();

    final currentUser = await getCurrentUser();
    final userEmail = currentUser?['email'] ?? 'unknown';

    final userImageKey = 'profile_image_$userEmail';
    await prefs.setString(userImageKey, url);
  }

  // جلب رابط الصورة
  Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();
    final userEmail = currentUser?['email'] ?? 'unknown';

    final userImageKey = 'profile_image_$userEmail';
    return prefs.getString(userImageKey);
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

  // حفظ بيانات مستخدم معينة
  static Future<void> saveUserData(
    String key,
    List<Map<String, dynamic>> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();
    final userEmail = currentUser?['email'] ?? 'unknown';

    final userKey = 'user_${userEmail}_$key';
    final dataJson = data.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList(userKey, dataJson);
  }

  // جلب بيانات مستخدم معينة
  static Future<List<Map>> getUserData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUser = await getCurrentUser();
    final userEmail = currentUser?['email'] ?? 'unknown';

    final userKey = 'user_${userEmail}_$key';
    final dataJson = prefs.getStringList(userKey);

    if (dataJson == null) return [];

    return dataJson
        .map((json) {
          try {
            return Map<String, dynamic>.from(jsonDecode(json));
          } catch (e) {
            return <String, dynamic>{};
          }
        })
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
