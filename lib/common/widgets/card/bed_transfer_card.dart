import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // Add for date and time formatting

class BedTransferCard extends StatelessWidget {
  final Map<String, dynamic> patient;
  final int index;
  final int selectedPatientIndex;
  final Function(int) onPatientSelected;

  const BedTransferCard({
    super.key,
    required this.patient,
    required this.index,
    required this.selectedPatientIndex,
    required this.onPatientSelected,
  });

  // Format the date and time coming from JSON
  String getFormattedDateTime(String dateTime) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    try {
      final DateTime parsedDate = DateTime.parse(
          dateTime); // Assuming the date is in ISO8601 format (e.g. '2025-04-28T16:45:00')
      return dateFormat.format(parsedDate);
    } catch (e) {
      return 'Invalid Date'; // Handle invalid date format
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedPatientIndex;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Name with Icon
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected ? DocvedaColors.primaryColor : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    DocvedaText(
                      text: patient["name"] ?? "",
                      style: TextStyleFont.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                /// Age • Gender
                DocvedaText(
                  text:
                      "${patient["age"]?.toString().replaceAll("Y", "") ?? "--"} Yrs • ${patient["gender"] ?? "--"}",
                  style: TextStyleFont.caption.copyWith(
                    color: Colors.grey,
                    // fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade100, thickness: 1),
            const SizedBox(height: 12),

            /// --- Date and Time (above the Bed Info) ---
            if (patient["dateTime"] != null) ...[
              Align(
                alignment: Alignment.center,
                child: DocvedaText(
                  text: getFormattedDateTime(patient["dateTime"]),
                  style: TextStyleFont.body.copyWith(
                    fontWeight: FontWeight.w400,
                    // fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            /// --- Bed Transfer Info ---
            Row(
              children: [
                /// From Bed (left aligned)
                DocvedaText(
                  text: patient["fromBed"] ?? "--",
                  style:
                      TextStyleFont.body.copyWith(fontWeight: FontWeight.w500),
                ),

                const SizedBox(width: 8),

                /// Arrow in the center taking full space
                Expanded(
                  child: Center(
                    child: Icon(
                      Iconsax.arrow_right_1,
                      size: 32,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// To Bed (right aligned)
                DocvedaText(
                  text: patient["toBed"] ?? "--",
                  style:
                      TextStyleFont.body.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
