import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthai/core/widget/custom_button.dart';
import 'package:healthai/core/widget/custom_text_field.dart';
import 'package:healthai/services/constants.dart';
import 'package:healthai/services/local_storage_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onProfileUpdated;
  const EditProfileScreen({super.key, this.onProfileUpdated});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = AppConstants.genders[0];
  String _selectedGoal = AppConstants.goals[0];
  String _selectedActivity = AppConstants.activityLevels[0];
  File? _selectedImage;
  bool _isLoading = false;
  bool _isInitialized = false;
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = await LocalStorageService.getCurrentUser();
      if (currentUser != null) {
        setState(() {
          _currentUserData = currentUser;
          _nameController.text = currentUser['name'] ?? '';
          _emailController.text = currentUser['email'] ?? '';
          _ageController.text = currentUser['age'] ?? '';
          _heightController.text = currentUser['height'] ?? '';
          _weightController.text = currentUser['weight'] ?? '';
          _selectedGender = currentUser['gender'] ?? AppConstants.genders[0];
          _selectedGoal = currentUser['goal'] ?? AppConstants.goals[0];
          _selectedActivity =
              currentUser['activityLevel'] ?? AppConstants.activityLevels[0];

          // تحميل الصورة إذا كانت موجودة
          final imagePath = currentUser['profileImage'];
          if (imagePath != null && imagePath.isNotEmpty && imagePath != '') {
            _selectedImage = File(imagePath);
          }

          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_currentUserData != null) {
          final updatedUser = {..._currentUserData!};
          updatedUser['name'] = _nameController.text;
          updatedUser['email'] = _emailController.text;
          updatedUser['age'] = _ageController.text;
          updatedUser['height'] = _heightController.text;
          updatedUser['weight'] = _weightController.text;
          updatedUser['goal'] = _selectedGoal;
          updatedUser['activityLevel'] = _selectedActivity;
          updatedUser['gender'] = _selectedGender;
          updatedUser['profileImage'] = _selectedImage?.path ?? '';

          final success = await LocalStorageService.updateUser(updatedUser);

          if (success && widget.onProfileUpdated != null) {
            // إرجاع البيانات المحدثة للصفحة الرئيسية
            widget.onProfileUpdated!(updatedUser);
          }

          if (!mounted) return;
          Navigator.pop(context); // إغلاق شاشة التعديل
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
          );
        }
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'تعديل الملف الشخصي',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // صورة البروفايل
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 58,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            child: _selectedImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF769DAD),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: _showImagePickerDialog,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // الاسم
                    CustomTextField(
                      controller: _nameController,
                      obscureText: false,
                      hintText: 'الاسم',
                      iconPath: 'assets/images/user.svg',
                      validator: (value) {
                        if (value!.isEmpty) return 'أدخل اسمك';
                        return null;
                      },
                    ),

                    // البريد الإلكتروني
                    CustomTextField(
                      controller: _emailController,
                      obscureText: false,
                      hintText: 'البريد الإلكتروني',
                      iconPath: 'assets/images/email.svg',
                      validator: (value) {
                        if (value!.isEmpty) return 'أدخل بريدك الإلكتروني';
                        if (!value.contains('@'))
                          return 'بريد إلكتروني غير صحيح';
                        return null;
                      },
                    ),

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
                    // الطول
                    CustomTextField(
                      controller: _heightController,
                      obscureText: false,
                      hintText: 'الطول (سم)',
                      iconPath: 'assets/images/thermometer.svg',
                      validator: (value) {
                        if (value!.isEmpty) return 'أدخل طولك';
                        if (double.tryParse(value) == null)
                          return 'طول غير صحيح';
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
                        if (double.tryParse(value) == null)
                          return 'وزن غير صحيح';
                        return null;
                      },
                    ),
                    // الجنس (Dropdown)
                    _buildDropdown(
                      'الجنس',
                      _selectedGender,
                      AppConstants.genders,
                      (value) {
                        setState(() => _selectedGender = value!);
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
                    CustomButton(
                      text: _isLoading ? 'جاري التحديث...' : 'تحديث المعلومات',
                      onPressed: _isLoading ? null : _updateProfile,
                    ),
                    const SizedBox(height: 20),
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// دالة لفتح صفحة التعديل كـ Bottom Sheet
void showEditProfileBottomSheet(
  BuildContext context, {
  Function(Map<String, dynamic>)? onProfileUpdated,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false, // لمنع الإغلاق بالسحب لأسفل
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) =>
          EditProfileScreen(onProfileUpdated: onProfileUpdated),
    ),
  );
}
