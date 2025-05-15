import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';

class ViewReportScreen extends StatelessWidget {
  final String patientName;
  final String age;
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
  final String? totalBill;
  final String? wardName;
  final String? bedName;
  final String? refundAmount;
  final String? discountAmount;
  final String? pendingAmount;
  final String? paidAmount;
  final String? doctorInCharge;
  final String? totalIpdBill;
  final String? visitDate;
  final String? deposite;
  final String? refund;
  final String? discount;

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
    this.totalBill,
    this.wardName,
    this.bedName,
    this.refundAmount,
    this.discountAmount,
    this.pendingAmount,
    this.paidAmount,
    this.doctorInCharge,
    this.totalIpdBill,
    this.visitDate,
    this.deposite,
    this.refund,
    this.discount,

  });

  @override
  Widget build(BuildContext context) {
    // Always shown fields
    final Map<String, Object> reportData = {
      "Name": patientName,
      "Age": age,
      "Gender": gender,
      "UHID No": uhidno ?? "-",
    };

    // Add screen-specific fields
    switch (screenName.toLowerCase()) {
      case "admission":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "UHID No": uhidno ?? "-",
          "Deposite": deposite ?? "-",
          "Total Bill": totalIpdBill ?? "-",
          "Ward Name": wardName ?? "-",
          "Bed Name": bedName ?? "-",
        });
        break;
      case "discharge":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Discharge Date": dischargeDate ?? "-",
          "Total Bill": totalIpdBill ?? "-",
        });
        break;
         case "opd visit":
        reportData.addAll({
          "Visit Date": visitDate ?? "-",
          "Doctor Name": doctorInCharge ?? "-",
         
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
          "Total Bill": totalIpdBill ?? "-",
          "Deposit": deposit ?? "-",
          "Pending Amount": pendingAmount ?? "-",
        });
        break;
      case "opd payment":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Bill Amount": billAmount ?? "-",
          "Date Of Payment": dateOfPayment ?? "-",
          "Paid Amount": paidAmount ?? "-",
          "Refund ": refund ?? "-",
          "Discount ": discount?? "-",
          "Doctor Name": doctorInCharge ?? "-",
        });
        break;
      case "opd bills":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Bill Amount": billAmount ?? "-",
          "Bill No": billNo ?? "-",
        });
        break;
      case "ipd settlement":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Doctor Name": doctorInCharge ?? "-",
          "Total Bill": totalIpdBill ?? "-",
          "Deposit": deposit ?? "-",
          "Final Settlement": finalSettlement ?? "-",
          "Refund Amount": refundAmount ?? "-",
          "Discount Amount": discountAmount ?? "-",
          "Discharge Date": dischargeDate ?? "-",
         
        });
        break;
      case "refund":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Refund Amount": refundAmount ?? "-",
          "Date Of Refund": dateOfRefund ?? "-",
        });
        break;
      case "discount":
        reportData.addAll({
          "Admission Date": admissionDate ?? "-",
          "Discount Amount": discountAmount ?? "-",
          "Date Of Discount": dateOfDiscount ?? "-",
        });
        break;
    }

    String convertToUnderscore(String input) =>
        input.replaceAll(' ', '_').toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: DocvedaText(
          text: "$screenName Report", //  Dynamic title
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
