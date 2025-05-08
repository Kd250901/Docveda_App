import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DocvedaTexts.notifications,
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.notifications_none,
              color: DocvedaColors.primaryColor,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Coming Up!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DocvedaColors.primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We're working on bringing you notifications soon.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
