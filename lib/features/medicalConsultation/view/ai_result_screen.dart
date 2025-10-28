import 'package:flutter/material.dart';

class AIResultScreen extends StatelessWidget {
  final String result;
  const AIResultScreen({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('النتيجة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(result, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
