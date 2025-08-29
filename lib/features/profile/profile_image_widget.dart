// profile_image_widget.dart
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/local_storage_service.dart';

class ProfileImageWidget extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const ProfileImageWidget({super.key, this.size = 100, this.onTap});

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  final LocalStorageService _userRepo = LocalStorageService();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final url = await _userRepo.getProfileImageUrl();
    setState(() => imageUrl = url);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });

      final currentUser = await LocalStorageService.getCurrentUser();
      if (currentUser != null) {
        final updatedUser = {...currentUser};
        updatedUser['profileImage'] = pickedFile.path;
        await LocalStorageService.updateUser(updatedUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? _pickImage,
      child: CircleAvatar(
        radius: widget.size,
        backgroundColor: Colors.grey[300],
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Icon(
        Icons.person,
        size: widget.size * 0.7,
        color: Colors.grey[600],
      );
    }

    // صورة من الإنترنت
    if (imageUrl!.startsWith('http')) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: widget.size * 2,
          height: widget.size * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    }

    // صورة من الجهاز (ملف محلي)
    return ClipOval(
      child: Image.file(
        File(imageUrl!),
        width: widget.size * 2,
        height: widget.size * 2,
        fit: BoxFit.cover,
      ),
    );
  }
}
