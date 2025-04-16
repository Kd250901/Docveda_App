import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
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
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItems),
        itemCount: 20, // Number of notifications (replace with dynamic data)
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: DocvedaColors.primaryColor,
              ),
              title: Text("${DocvedaTexts.notificationTitle} ${index + 1}"),
              subtitle: const Text(DocvedaTexts.notificationsDesc),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Handle notification click
              },
            ),
          );
        },
      ),
    );
  }
}
