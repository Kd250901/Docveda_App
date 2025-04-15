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
        title: const Text(
          "Discharge Report",
          style: TextStyle(
            fontFamily: "Manrope",
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Remove extra white spacing by starting directly after the appbar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Patient: $patientName",
                    style: const TextStyle(
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Age: $age",
                    style: const TextStyle(fontFamily: "Manrope"),
                  ),
                  Text(
                    "Gender: $gender",
                    style: const TextStyle(fontFamily: "Manrope"),
                  ),
                  Text(
                    "Admission Date: $admissionDate",
                    style: const TextStyle(fontFamily: "Manrope"),
                  ),
                  Text(
                    "Discharge Date: $dischargeDate",
                    style: const TextStyle(fontFamily: "Manrope"),
                  ),
                  Text(
                    "Final Settlement: $finalSettlement",
                    style: const TextStyle(fontFamily: "Manrope"),
                  ),
                ],
              ),
            ),
          ),

          // Button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DocvedaColors.primaryColor,
                ),
                onPressed: () {
                  // Handle report download
                },
                child: const Text(
                  "Download Report",
                  style: TextStyle(
                    fontFamily: "Manrope",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
