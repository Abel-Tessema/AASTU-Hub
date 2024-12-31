import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Effective Date: 12/31/2024 G.C\n\n'
              'Welcome to AASTU Hub! By using our app, you agree to these Terms and Conditions.\n\n'
              '1. Acceptance of Terms\n'
              '- By accessing or using the App, you agree to be bound by these Terms and our Privacy Policy.\n\n'
              '2. Eligibility\n'
              '- Be at least 13 years old or have parental/guardian consent if required by your jurisdiction.\n'
              '- Provide accurate and complete information when creating an account.\n\n'
              '3. User Responsibilities\n'
              '- Use the App only for lawful purposes.\n'
              '- Keep your account credentials confidential.\n'
              '- Refrain from uploading malicious content.\n\n'
              '4. Intellectual Property\n'
              '- All content in the App is the property of AASTU Hub or its licensors.\n\n'
              '5. Disclaimer of Warranties\n'
              '- The App is provided “AS IS” and “AS AVAILABLE.”\n'
              '- No guarantees about functionality or accuracy.\n\n'
              '6. Limitation of Liability\n'
              '- We are not liable for any indirect, incidental, or consequential damages arising from your use of the App.\n\n'
              '7. Termination\n'
              '- We reserve the right to terminate your access to the App for violations of these Terms.\n\n'
              '8. Governing Law\n'
              '- These Terms are governed by the laws of the Federal Democratic Republic of Ethiopia.\n\n'
              '9. Changes to Terms\n'
              '- Updates to these Terms will be communicated through the App.\n\n'
              '10. Contact Us\n'
              '- For questions about these Terms, email us at abelxotessema@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
