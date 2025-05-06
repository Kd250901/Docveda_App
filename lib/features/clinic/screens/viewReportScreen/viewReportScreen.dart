import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';

class ViewReportScreen extends StatelessWidget {
  final String patientName;
  final int age;
  final String gender;
  final String screenName;

  // Optional fields for different screens
  final String? admissionDate;
  final String? dischargeDate;
  final String? finalSettlement;
  final String? deposit;
  final String? uhidno;
  final String? bedTransferDate;
  final String? bedTransferTime;
  final String? fromWard;
  final String? toWard;
  final String? fromBed;
  final String? toBed;
  final String? billAmount;
  final String? billNo;
  final String? dateOfPayment;
  final String? dateOfRefund;
  final String? dateOfDiscount;
  final String? totalIpdBill;
  final String? wardName;
  final String? bedName;

  const ViewReportScreen({
    super.key,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.screenName,
    this.admissionDate,
    this.dischargeDate,
    this.finalSettlement,
    this.deposit,
    this.uhidno,
    this.bedTransferDate,
    this.bedTransferTime,
    this.fromWard,
    this.toWard,
    this.fromBed,
    this.toBed,
    this.billAmount,
    this.billNo,
    this.dateOfPayment,
    this.dateOfRefund,
    this.dateOfDiscount,
    this.totalIpdBill,
    this.wardName,
    this.bedName,
  });

  @override
  Widget build(BuildContext context) {
    // Always shown fields
    final Map<String, Object> reportData = {
      "Name": patientName,
      "Age": age,
      "Gender": gender,
    };

    // Add screen-specific fields
    switch (screenName.toLowerCase()) {
      case "admission":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "UHID No": uhidno ?? "-",
          "Deposit": deposit ?? "-",
          "Total Bill": totalIpdBill ?? "-",
          "Ward Name": wardName ?? "-",
          "Bed Name": bedName ?? "-",
        });
        break;
      case "discharge":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Discharge Date": dischargeDate ?? "-",
          "Bill Amount": finalSettlement ?? "-",
        });
        break;
      case "bed transfer":
        reportData.addAll({
          "Bed Transfer Date": bedTransferDate ?? "-",
          "Bed Transfer Time": bedTransferTime ?? "-",
          "From Ward": fromWard ?? "-",
          "To Ward": toWard ?? "-",
          "From Bed": fromBed ?? "-",
          "To Bed": toBed ?? "-",
        });
        break;
      case "deposit":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "UHID No": uhidno ?? "-",
          "Total Ipd Bill": totalIpdBill ?? "-",
          "Deposit": deposit ?? "-",
        });
        break;
      case "opd payments":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Bill Amount": finalSettlement ?? "-",
          "Date Of Payment": dateOfPayment ?? "-",
        });
        break;
      case "opd bills":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Bill Amount": finalSettlement ?? "-",
          "Bill No": billNo ?? "-",
        });
        break;
      case "ipd settlement":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Total IPD Bill": finalSettlement ?? "-",
          "Final Settlement": finalSettlement ?? "-",
          "Discharge Date": dischargeDate ?? "-",
        });
        break;
      case "refund":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Refund Amount": finalSettlement ?? "-",
          "Date Of Refund": dateOfRefund ?? "-",
        });
        break;
      case "discount":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Discount Amount": finalSettlement ?? "-",
          "Date Of Discount": dateOfDiscount ?? "-",
        });
        break;
    }

    String convertToUnderscore(String input) =>
        input.replaceAll(' ', '_').toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: DocvedaText(
          text: "$screenName Report", // ✅ Dynamic title
          style: const TextStyle(color: DocvedaColors.white),
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
                  children: reportData.entries
                      .map((e) => _buildInfoRow(e.key, e.value.toString()))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: () {
                  Pdf.generateAndDownloadPDF(
                    title: "$screenName Patient Report",
                    data: reportData,
                    fileName:
                        "${convertToUnderscore(patientName)}_${convertToUnderscore(screenName)}_report.pdf",
                  );
                },
                text: DocvedaTexts.downloadReport,
                backgroundColor: DocvedaColors.primaryColor,
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
              fontWeight: FontWeight.w900,
              fontSize: DocvedaSizes.fontSizeSm,
              color: DocvedaColors.darkGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Manrope",
              fontSize: DocvedaSizes.fontSizeSm,
              color: DocvedaColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
