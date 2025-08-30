import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthai/features/profile/edit_profile_screen.dart'; // تأكد من هذا الاستيراد
import 'package:healthai/features/profile/register/login_screen.dart';
import 'package:healthai/services/local_storage_service.dart';

import '../../Setting/settings_page.dart';

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
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تأكيد الحذف"),
          content: const Text(
            "هل أنت متأكد من أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                _deleteAccount();
              },
              child: const Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
    if (userData != null && userData!['email'] != null) {
      await LocalStorageService.deleteUser(userData!['email']);
    }
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم حذف الحساب بنجاح")));
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
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFFFFFFFF)),
                    const SizedBox(width: 8),
                    const Text(
                      "تعديل البيانات الشخصية",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFFFFFFFF)),
                    const SizedBox(width: 8),
                    const Text(
                      "الإعدادات",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      "تسجيل الخروج",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      "حذف الحساب",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(value),
        ],
      ),
    );
  }
}
