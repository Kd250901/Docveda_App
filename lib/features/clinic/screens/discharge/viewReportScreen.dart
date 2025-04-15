import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';

class ViewReportScreen extends StatelessWidget {
  final String patientName;
  final int age;
  final String gender;
  final String admissionDate;
  final String dischargeDate;
  final String finalSettlement;

  const ViewReportScreen({
    super.key,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.admissionDate,
    required this.dischargeDate,
    required this.finalSettlement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "Discharge Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Name
                    Text(
                      "Patient: $patientName",
                      style: const TextStyle(
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    _buildInfoRow("Age", age.toString()),
                    _buildInfoRow("Gender", gender),
                    _buildInfoRow("Admission Date", admissionDate),
                    _buildInfoRow("Discharge Date", dischargeDate),
                    _buildInfoRow("Final Settlement", finalSettlement),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Download Button without background or border
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  // Handle report download
                },
                text: 'Download Report',
                backgroundColor: DocvedaColors.primaryColor,
                // No background color or border here
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
