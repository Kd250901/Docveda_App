import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';

class PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;
  final int index;
  final int selectedPatientIndex;
  final Function(int) onPatientSelected;

  const PatientCard({
    super.key,
    required this.patient,
    required this.index,
    required this.selectedPatientIndex,
    required this.onPatientSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedPatientIndex;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => onPatientSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? DocvedaColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Top Row: Name + Age + Gender ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Icon + Name
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: isSelected
                            ? DocvedaColors.primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DocvedaText(
                          text: patient["name"] ?? "",
                          style: TextStyleFont.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Age + Gender
                DocvedaText(
                  text:
                      "${patient["age"].toString().replaceAll('Y', '')} Yrs • ${patient["gender"] ?? "--"}",
                  style: TextStyleFont.caption.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),

            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade100, thickness: 1),
            const SizedBox(height: 4),

            /// --- Middle Row: Admission & Discharge ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Admission
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DocvedaText(
                      text: "ADMISSION",
                      style: TextStyleFont.caption.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DocvedaText(
                      text: patient["admission"] ?? "--",
                      style: TextStyleFont.caption,
                    ),
                  ],
                ),

                /// Discharge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DocvedaText(
                      text: "DISCHARGE",
                      style: TextStyleFont.caption.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DocvedaText(
                      text: patient["discharge"] ?? "--",
                      style: TextStyleFont.caption,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// --- Bottom: Bill Amount ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DocvedaText(
                    text: "BILL AMOUNT",
                    style: TextStyleFont.caption.copyWith(color: Colors.grey),
                  ),
                  DocvedaText(
                    text: "₹${patient["billAmount"] ?? "0"}",
                    style: TextStyleFont.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
