import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';

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

    return GestureDetector(
      onTap: () => onPatientSelected(index), // Handle patient selection
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? DocvedaColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Patient Name and Info**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(patient["name"], style: TextStyleFont.body),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${patient["age"]} Years", style: TextStyleFont.body),
                    Text(patient["gender"], style: TextStyleFont.body),
                  ],
                ),
              ],
            ),
            //const SizedBox(height: 100),

            /// **Thin grey line separator**
            Divider(color: Colors.grey.shade300),

            // const SizedBox(height: 100),

            /// **Admission and Discharge Info**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ADMISSION",
                      style: TextStyleFont.caption.copyWith(color: Colors.grey),
                    ),
                    Text(patient["admission"], style: TextStyleFont.caption),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "DISCHARGE",
                      style: TextStyleFont.caption.copyWith(color: Colors.grey),
                    ),
                    Text(patient["discharge"], style: TextStyleFont.caption),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
