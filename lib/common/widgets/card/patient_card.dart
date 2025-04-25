import 'package:flutter/material.dart';
import 'package:docveda_app/utils/constants/colors.dart';

class PatientCard extends StatelessWidget {
  final int index;
  final int selectedPatientIndex;
  final Function(int) onPatientSelected;

  final Widget topRow;
  final Widget middleRow;
  final Widget bottomRow;

  const PatientCard({
    super.key,
    required this.index,
    required this.selectedPatientIndex,
    required this.onPatientSelected,
    required this.topRow,
    required this.middleRow,
    required this.bottomRow,
  });

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
            topRow, // Custom topRow widget
            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade100, thickness: 1),
            const SizedBox(height: 4),
            middleRow, // Custom middleRow widget
            const SizedBox(height: 16),
            bottomRow, // Custom bottomRow widget
          ],
        ),
      ),
    );
  }
}
