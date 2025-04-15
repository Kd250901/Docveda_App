import 'package:docveda_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 20, // Number of notifications (replace with dynamic data)
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: Colors.deepPurple,
              ),
              title: Text("Notification ${index + 1}"),
              subtitle: const Text("This is a sample notification message."),
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
