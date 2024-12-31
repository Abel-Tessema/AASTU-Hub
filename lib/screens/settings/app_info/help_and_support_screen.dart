import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Need assistance? We’re here to help!\n\n'
              'If you encounter any issues while using AASTU Hub or have questions about its features, please don’t hesitate to reach out.\n\n'
              'Here’s how you can get support:\n\n'
              '1. Email Us\n'
              '   - Contact: abelxotessema@gmail.com\n\n'
              '2. Feedback\n'
              '   - Let us know how we can improve by sending your suggestions to our email.\n\n'
              'Thank you for using AASTU Hub. Your feedback is valuable to us!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
