import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../../navigation/main_screen.dart';
import '../../services/constants.dart';
import '../../services/local_storage_service.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userName;
  final String email;

  const CompleteProfileScreen({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = AppConstants.genders[0];
  String _selectedGoal = AppConstants.goals[0];
  String _selectedActivity = AppConstants.activityLevels[0];
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _completeProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // جلب المستخدم الحالي من التخزين
        final currentUser = await LocalStorageService.getCurrentUser();

        if (currentUser != null) {
          final updatedUser = {...currentUser};
          updatedUser['name'] = widget.userName;
          updatedUser['email'] = widget.email;
          updatedUser['age'] = _ageController.text;
          updatedUser['height'] = _heightController.text;
          updatedUser['weight'] = _weightController.text;
          updatedUser['goal'] = _selectedGoal;
          updatedUser['activityLevel'] = _selectedActivity;
          updatedUser['gender'] = _selectedGender;
          updatedUser['profileImage'] = _selectedImage?.path ?? '';

          await LocalStorageService.updateUser(updatedUser);
        } else {
          // لو المستخدم مش موجود، نعمل إدخال جديد
          final newUser = {
            'name': widget.userName,
            'email': widget.email,
            'age': _ageController.text,
            'height': _heightController.text,
            'weight': _weightController.text,
            'goal': _selectedGoal,
            'activityLevel': _selectedActivity,
            'gender': _selectedGender,
            'profileImage': _selectedImage?.path ?? '',
          };

          await LocalStorageService.updateUser(newUser);
        }

        if (!mounted) return;
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر صورة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أكمل معلوماتك الشخصية')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              // صورة البروفايل
              Stack(
                children: [
                  CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _showImagePickerDialog,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // العمر
              CustomTextField(
                controller: _ageController,
                obscureText: false,
                hintText: 'العمر',
                iconPath: 'assets/images/user.svg',
                validator: (value) {
                  if (value!.isEmpty) return 'أدخل عمرك';
                  if (int.tryParse(value) == null) return 'عمر غير صحيح';
                  return null;
                },
              ),

              // الجنس (Dropdown)
              _buildDropdown('الجنس', _selectedGender, AppConstants.genders, (
                value,
              ) {
                setState(() => _selectedGender = value!);
              }),

              // الطول
              CustomTextField(
                controller: _heightController,
                obscureText: false,
                hintText: 'الطول (سم)',
                iconPath: 'assets/images/thermometer.svg',
                validator: (value) {
                  if (value!.isEmpty) return 'أدخل طولك';
                  if (double.tryParse(value) == null) return 'طول غير صحيح';
                  return null;
                },
              ),

              // الوزن
              CustomTextField(
                controller: _weightController,
                obscureText: false,
                hintText: 'الوزن (كجم)',
                iconPath: 'assets/images/dumbbell.svg',
                validator: (value) {
                  if (value!.isEmpty) return 'أدخل وزنك';
                  if (double.tryParse(value) == null) return 'وزن غير صحيح';
                  return null;
                },
              ),

              // الهدف
              _buildDropdown('الهدف', _selectedGoal, AppConstants.goals, (
                value,
              ) {
                setState(() => _selectedGoal = value!);
              }),

              // مستوى النشاط
              _buildDropdown(
                'مستوى النشاط',
                _selectedActivity,
                AppConstants.activityLevels,
                (value) {
                  setState(() => _selectedActivity = value!);
                },
              ),

              const SizedBox(height: 20),
              CustomButton(
                text: _isLoading ? 'جاري الحفظ...' : 'حفظ المعلومات',
                onPressed: _isLoading ? null : _completeProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
