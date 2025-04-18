import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
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
          text: DocvedaTexts.dischargeRepost,
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DocvedaSizes.buttonRadius),
              ),
              color: DocvedaColors.white,
              child: Padding(
                padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItems),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient Name
                    Text(
                      "Patient: $patientName",
                      style: const TextStyle(
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.bold,
                        fontSize: DocvedaSizes.fontSizeXlg,
                      ),
                    ),
                    const SizedBox(height: DocvedaSizes.spaceBtwItemsSm),
                    Divider(color: DocvedaColors.lightGrey),
                    const SizedBox(height: DocvedaSizes.spaceBtwItemsSm),
                    _buildInfoRow("Age", age.toString()),
                    _buildInfoRow("Gender", gender),
                    _buildInfoRow("Admission Date", admissionDate),
                    _buildInfoRow("Discharge Date", dischargeDate),
                    _buildInfoRow("Final Settlement", finalSettlement),
                  ],
                ),
              ),
            ),

            const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),

            // Download Button without background or border
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  // Handle report download
                },
                text: DocvedaTexts.downloadReport,
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
      padding: const EdgeInsets.symmetric(vertical: DocvedaSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontWeight: FontWeight.bold,
              fontSize: DocvedaSizes.fontSizeMd,
              color: DocvedaColors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontSize: DocvedaSizes.fontSizeMd,
              color: DocvedaColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
