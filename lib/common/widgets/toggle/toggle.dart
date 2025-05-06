import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docveda_app/common/widgets/app_text/app_text.dart';

class DocvedaToggle extends StatelessWidget {
  final void Function(bool)? onToggle; // Add onToggle callback

  const DocvedaToggle({Key? key, this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ToggleController toggleController = Get.find();

    return Obx(() {
      return Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          color: DocvedaColors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: DocvedaColors.white,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: toggleController.isMonthly.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: DocvedaColors.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      toggleController.toggle(true);
                      onToggle?.call(true); // Notify parent
                    },
                    child: Center(
                      child: DocvedaText(
                        text: "MONTHLY",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: toggleController.isMonthly.value
                              ? DocvedaColors.white
                              : DocvedaColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      toggleController.toggle(false);
                      onToggle?.call(false); // Notify parent
                    },
                    child: Center(
                      child: DocvedaText(
                        text: "DAILY",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: toggleController.isMonthly.value
                              ? DocvedaColors.primaryColor
                              : DocvedaColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
