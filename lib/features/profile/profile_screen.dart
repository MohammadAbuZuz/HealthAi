import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthai/features/profile/edit_profile_screen.dart'; // تأكد من هذا الاستيراد
import 'package:healthai/features/profile/register/login_screen.dart';
import 'package:healthai/services/local_storage_service.dart';

import '../Setting/settings_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await LocalStorageService.getCurrentUser();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  // دالة لتحديث البيانات محلياً بعد التعديل - هذه الدالة لازم تكون موجودة
  void _updateUserData(Map<String, dynamic> updatedData) {
    setState(() {
      userData = updatedData;
    });
    // حفظ البيانات المحدثة في التخزين المحلي مع استدعاء دالة _deleteAccount(); من local
    LocalStorageService.updateUser(updatedData);
  }

  //رسالة تأكديد لحذف الحساب مع الحذف
  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "تأكيد الحذف",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_forever, color: Colors.red, size: 30),
              SizedBox(height: 10),
              Text(
                "هل أنت متأكد من أنك تريد حذف حسابك؟",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                "لا يمكن التراجع عن هذا الإجراء.",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel_outlined, size: 18),
                  SizedBox(width: 4),
                  Text("إلغاء"),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // إرجاع true للموافقة
                _deleteAccount(); // استدعاء دالة الحذف
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever, size: 18, color: Colors.red),
                  SizedBox(width: 4),
                  Text("حذف", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        _deleteAccount(); // التأكد من استدعاء الحذف إذا وافق المستخدم
      }
    });
  }
  //رسالة تأكيد لتسجيل الخروج

  Future<void> _showLogoutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد الخروج"),
          content: const Text("هل أنت متأكد من أنك تريد تسجيل الخروج؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _signOut();
              },
              child: const Text("خروج", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      if (userData != null && userData!['email'] != null) {
        await LocalStorageService.deleteUser(userData!['email']);

        if (!mounted) return;

        // إظهار رسالة نجاح
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم حذف الحساب بنجاح")));

        // الانتقال إلى شاشة تسجيل الدخول
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لا يمكن العثور على بيانات المستخدم")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء حذف الحساب: $e")));
    }
  }

  Future<void> _signOut() async {
    await LocalStorageService.clearCurrentUser();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم تسجيل الخروج بنجاح")));
  }

  // دالة للتعامل مع خيارات القائمة
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        // الانتقال إلى شاشة التعديل
        showEditProfileBottomSheet(
          context,
          onProfileUpdated: _updateUserData, // هنا بنمرر الدالة
        );
        break;
      case 'logout':
        _showLogoutConfirmation();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
      case 'settings':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userData == null) {
      return const Scaffold(body: Center(child: Text("لا يوجد بيانات مستخدم")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF769DAD),
        title: const Text("البروفايل", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            color: const Color(0xFF769DAD),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.white),
                  title: const Text(
                    "تعديل البيانات",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "الإعدادات",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const PopupMenuDivider(height: 1),
              PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: ListTile(
                  leading: const Icon(
                    Icons.delete_forever,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "حذف الحساب",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
            offset: const Offset(0, 50),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  userData!['profileImage'] != null &&
                      userData!['profileImage'].toString().isNotEmpty
                  ? FileImage(File(userData!['profileImage']))
                  : null,
              child:
                  userData!['profileImage'] == null ||
                      userData!['profileImage'].toString().isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 40),

          _buildInfoCard("المعلومات الأساسية", [
            _buildInfoRow("الاسم", userData!['name'] ?? ""),
            _buildInfoRow("البريد", userData!['email'] ?? ""),
          ]),

          _buildInfoCard("المعلومات الشخصية", [
            _buildInfoRow("العمر", "${userData!['age'] ?? ''}"),
            _buildInfoRow("الجنس", userData!['gender'] ?? ""),
            _buildInfoRow("الطول", "${userData!['height'] ?? ''} سم"),
            _buildInfoRow("الوزن", "${userData!['weight'] ?? ''} كجم"),
            _buildInfoRow("الهدف", userData!['goal'] ?? ""),
            _buildInfoRow("النشاط", userData!['activityLevel'] ?? ""),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label :",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
