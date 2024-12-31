import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Effective Date: 12/31/2024 G.C\n\n'
              'AASTU Hub is committed to protecting your privacy. '
              'This Privacy Policy explains how we collect, use, and protect your information when you use our app, which provides information about university resources and allows you to store and calculate grades upon sign-in.\n\n'
              '1. Information We Collect\n'
              '- Personal Information: Name, Email address, Phone number.\n'
              '- Usage Data: Device information, Log information, App usage data.\n'
              '- Stored Data: Data input for grade storage and calculation is securely stored.\n\n'
              '2. How We Use Your Information\n'
              '- Provide, maintain, and improve the App’s functionality.\n'
              '- Personalize your experience.\n'
              '- Respond to inquiries or support requests.\n'
              '- Send important updates about the App.\n\n'
              '3. How We Share Your Information\n'
              '- With service providers.\n'
              '- For legal reasons.\n'
              '- In aggregated form for analytics or research purposes.\n\n'
              '4. Data Security\n'
              '- Industry-standard security measures are implemented to protect your information.\n'
              '- However, no system is entirely secure.\n\n'
              '5. Your Rights\n'
              '- Access, or correct your account and associated data.\n'
              '- Contact us at abelxotessema@gmail.com to exercise these rights.\n\n'
              '6. Third-Party Links\n'
              '- Not responsible for external sites’ privacy practices.\n\n'
              '7. Changes to This Privacy Policy\n'
              '- Updates will be posted here, with significant changes communicated to users.\n\n'
              '8. Contact Us\n'
              '- For questions, email us at abelxotessema@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
