import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            /// Main Content
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Purple Header with custom header container
                    DocvedaPrimaryHeaderContainer(
                      child: Column(
                        children: [
                          DocvedaAppBar(
                            title: const Center(
                              child: DocvedaText(
                                text: 'Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            showBackArrow: true,
                          ),
                          const SizedBox(height: 12),
                          const CircleAvatar(
                            radius: 36,
                            backgroundImage:
                                AssetImage(DocvedaImages.clinicLogo),
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          const DocvedaText(
                            text: "Samarth Hospital",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    /// Info Tiles
                    const SizedBox(height: 16),
                    _buildInfoTile("Doctor Name", "Dr. Shailesh Kulkarni"),
                    _buildInfoTile("Mobile Number", "+91 9876543210"),
                    _buildInfoTile("Email ID", "shaileshk@gmail.com"),
                    _buildInfoTile("Area", "Tilak Nagar"),
                    _buildInfoTile("City", "Mumbai"),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            /// Fixed App Version
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: DocvedaText(
                  text: "App Version\nv 1.0.1",
                  textAlign: TextAlign.center,
                  style: TextStyleFont.body.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildInfoTile(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocvedaText(
            text: title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          DocvedaText(
            text: value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
