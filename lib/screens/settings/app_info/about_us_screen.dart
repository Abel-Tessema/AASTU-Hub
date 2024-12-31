import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to AASTU Hub!\n\n'
              'Our mission is to empower students at the Addis Ababa Science and Technology University (AASTU) by providing an all-in-one platform to access university resources and manage their academic performance. \n\n'
              'Through AASTU Hub, users can explore university facilities, stay informed about campus updates, and easily calculate and store their grades in a secure environment.\n\n'
              'We are dedicated to enhancing the academic experience and fostering a sense of community among students. Thank you for choosing AASTU Hub as your academic companion.\n\n'
              'For any questions or feedback, feel free to reach out to us at abelxotessema@gmail.com.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
