import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/features/profile/register/login_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/constants.dart';
import '../../services/local_storage_service.dart';
import '../../services/responsive.dart'; // ✅ ضفنا كلاس Responsive

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
        final currentUser = await LocalStorageService.getCurrentUser();
        final updatedUser = {
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

        await LocalStorageService.updateUser(updatedUser);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
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
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أكمل معلوماتك الشخصية',
          style: TextStyle(
            fontSize: Responsive.fontSize(
              context,
              mobile: 18,
              tablet: 20,
              desktop: 22,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: Responsive.responsivePadding(
          context,
          mobile: const EdgeInsets.all(16),
          tablet: const EdgeInsets.all(24),
          desktop: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: Responsive.responsiveValue(
                  context,
                  mobile: 10,
                  tablet: 20,
                  desktop: 40,
                ),
              ),

              // صورة البروفايل
              Stack(
                children: [
                  CircleAvatar(
                    radius: Responsive.responsiveValue(
                      context,
                      mobile: 50,
                      tablet: 70,
                      desktop: 90,
                    ),
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(
                            Icons.person,
                            size: Responsive.responsiveValue(
                              context,
                              mobile: 40,
                              tablet: 60,
                              desktop: 80,
                            ),
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: Responsive.responsiveValue(
                        context,
                        mobile: 18,
                        tablet: 22,
                        desktop: 26,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: Responsive.responsiveValue(
                            context,
                            mobile: 16,
                            tablet: 20,
                            desktop: 24,
                          ),
                        ),
                        onPressed: _showImagePickerDialog,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: Responsive.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                ),
              ),

              // الحقول
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

              _buildDropdown('الجنس', _selectedGender, AppConstants.genders, (
                value,
              ) {
                setState(() => _selectedGender = value!);
              }),

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

              _buildDropdown('الهدف', _selectedGoal, AppConstants.goals, (
                value,
              ) {
                setState(() => _selectedGoal = value!);
              }),

              _buildDropdown(
                'مستوى النشاط',
                _selectedActivity,
                AppConstants.activityLevels,
                (value) {
                  setState(() => _selectedActivity = value!);
                },
              ),

              SizedBox(
                height: Responsive.responsiveValue(
                  context,
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                ),
              ),

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
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                fontSize: Responsive.fontSize(
                  context,
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          labelText: title,
          labelStyle: TextStyle(
            fontSize: Responsive.fontSize(
              context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
