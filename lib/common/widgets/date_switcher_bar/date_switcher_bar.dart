import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class DateSwitcherBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isMonthly;
  final Color textColor;
  final double fontSize;

  const DateSwitcherBar({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
    required this.isMonthly,
    this.textColor = Colors.white,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = isMonthly
        ? DateFormat("MMM, yyyy").format(selectedDate)
        : DateFormat("dd MMM, yyyy").format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Iconsax.arrow_left_2),
          onPressed: onPrevious,
          style: ButtonStyle(iconColor: MaterialStateProperty.all(textColor)),
        ),
        const SizedBox(width: 12),
        DocvedaText(
          text: formattedDate,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Iconsax.arrow_right_3),
          onPressed: onNext,
          style: ButtonStyle(iconColor: MaterialStateProperty.all(textColor)),
        ),
      ],
    );
  }
}
