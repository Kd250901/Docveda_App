import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          DocvedaTexts.analytics,
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.query_stats,
              color: DocvedaColors.primaryColor,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Coming Soon!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DocvedaColors.primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Analytics will be available in a future update.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
