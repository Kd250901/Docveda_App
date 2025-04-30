import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/format_name.dart';
import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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

  // Using the formatted date and time
  String getFormattedDate(String date) {
    final DateFormat dateFormat = DateFormat('dd MMM yyyy');
    try {
      final DateTime parsedDate = DateFormat('dd/MM/yyyy')
          .parse(date); // Assuming the date is in 'dd/MM/yyyy' format
      return dateFormat.format(parsedDate);
    } catch (e) {
      return 'Invalid Date'; // Handle invalid date format
    }
  }

  String getFormattedTime(String time) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    try {
      final DateTime parsedTime = DateFormat('HH:mm')
          .parse(time); // Assuming the time is in 'HH:mm' format
      return timeFormat.format(parsedTime);
    } catch (e) {
      return 'Invalid Time'; // Handle invalid time format
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedPatientIndex;

    return GestureDetector(
      onTap: () => onPatientSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: DocvedaSizes.spaceBtwItemsSm,
            horizontal: DocvedaSizes.spaceBtwItems),
        padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItems),
        decoration: BoxDecoration(
          color: DocvedaColors.white, // Keep the background white
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
                      color: isSelected
                          ? DocvedaColors.primaryColor
                          : DocvedaColors.grey,
                      size: DocvedaSizes.iconXlg,
                    ),
                    const SizedBox(width: 8),
                    DocvedaText(
                      text: formatPatientName(patient["Patient Name"] ?? ""),
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
                      "${patient["Age"]?.toString() ?? "--"} • ${patient["Gender"] ?? "--"}",
                  style: TextStyleFont.caption.copyWith(
                    color: DocvedaColors.darkGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: DocvedaColors.grey, thickness: 1),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.center,
              child: DocvedaText(
                text:
                    '${getFormattedDate(patient["Bed_Start_Date"] ?? "")}, ${getFormattedTime(patient["f_HIS_Bed_Start_Time"] ?? "")}',
                style: TextStyleFont.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: DocvedaColors.darkGrey,
                ),
              ),
            ),

            /// --- Ward Info ---
            Row(
              children: [
                /// From Ward (top)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FROM WARD
                      DocvedaText(
                        text: patient["FROM WARD"] ?? "--",
                        style: TextStyleFont.body
                            .copyWith(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        // Let text wrap naturally
                      ),
                      const SizedBox(height: 4),

                      // FROM BED
                      DocvedaText(
                        text: patient["FROM BED"] ?? "--",
                        style: TextStyleFont.body
                            .copyWith(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                /// Arrow in the center
                Expanded(
                  child: Center(
                    child: Icon(
                      Iconsax.arrow_right_1,
                      size: DocvedaSizes.iconXlg,
                      color: DocvedaColors.grey,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                /// To Ward (top) and To Bed (below it)
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DocvedaText(
                        text: patient["TO WARD"] ?? "--",
                        style: TextStyleFont.body
                            .copyWith(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      const SizedBox(height: 4),
                      DocvedaText(
                        text: patient["TO BED"] ?? "--",
                        style: TextStyleFont.body
                            .copyWith(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            /// --- Date and Time Info ---
          ],
        ),
      ),
    );
  }
}
