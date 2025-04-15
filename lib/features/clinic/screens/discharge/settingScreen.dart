import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/new_password_screen.dart';
import 'package:docveda_app/features/clinic/screens/home/analytics/analytics.dart';
import 'package:docveda_app/features/clinic/screens/home/notifications/notifications.dart';
import 'package:docveda_app/features/clinic/screens/settings/profile_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Main scrollable content
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),

                // Profile
                ListTile(
                  leading: Icon(Iconsax.user, color: DocvedaColors.primary),
                  title: const DocvedaText(text: "Profile"),
                  subtitle:
                      const DocvedaText(text: "Manage your profile details"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(const ProfileScreen()),
                ),
                const Divider(),

                // Notifications
                ListTile(
                  leading:
                      Icon(Iconsax.notification, color: DocvedaColors.primary),
                  title: const DocvedaText(text: "Notifications"),
                  subtitle: const DocvedaText(text: "Notification preferences"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(const NotificationsScreen()),
                ),
                const Divider(),

                // Analytics
                ListTile(
                  leading: Icon(Iconsax.chart, color: DocvedaColors.primary),
                  title: const Text("Analytics"),
                  subtitle: const Text("View usage statistics"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(const AnalyticsScreen()),
                ),
                const Divider(),

                // Change Password
                ListTile(
                  leading: Icon(Iconsax.lock, color: DocvedaColors.primary),
                  title: const Text("Change Password"),
                  subtitle: const Text("Update your login credentials"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Get.to(() => const NewPasswordScreen()),
                ),
                const Divider(),

                // Logout
                ListTile(
                  leading: const Icon(
                    Iconsax.logout_1,
                    color: DocvedaColors.primaryColor,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: DocvedaColors.primaryColor),
                  ),
                  onTap: () {
                    Get.defaultDialog(
                      title: "Confirm Logout",
                      titleStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: DocvedaColors.primaryColor,
                      ),
                      middleText: "Are you sure you want to logout?",
                      middleTextStyle: const TextStyle(fontSize: 16),
                      backgroundColor: Colors.white,
                      radius: 10,
                      textCancel: "Cancel",
                      cancelTextColor: DocvedaColors.primaryColor,
                      textConfirm: "Logout",
                      confirmTextColor: Colors.white,
                      buttonColor: DocvedaColors.primaryColor,
                      onConfirm: () {
                        StorageHelper.clearTokens();
                        Get.offAll(() => const LoginScreen());
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // App version text pinned at the bottom
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Center(
              child: Text(
                "App Version\nv 1.0.1",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
