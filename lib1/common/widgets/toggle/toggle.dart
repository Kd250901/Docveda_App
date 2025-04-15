import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';

class DocvedaToggle extends StatefulWidget {
  const DocvedaToggle({super.key});

  @override
  State<StatefulWidget> createState() => _DocvedaToggleState();
}

class _DocvedaToggleState extends State<DocvedaToggle> {
  bool isMonthly = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Ensuring the toggle is centered
      child: Container(
        width: 200, // Fixed width
        height: 40, // Fixed height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color.fromARGB(255, 248, 246, 248),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Sliding Effect Background
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment:
                  isMonthly ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(2), // Prevents overflow
                child: Container(
                  width: 98, // Slightly less than half to fit properly
                  height: 36, // Slightly less than height to fit inside padding
                  decoration: BoxDecoration(
                    color: DocvedaColors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = true;
                      });
                    },
                    child: Center(
                      child: Text(
                        "MONTHLY",
                        style: TextStyleFont.button.copyWith(
                          // Use your global text style here
                          color:
                              isMonthly
                                  ? Colors.white
                                  : DocvedaColors
                                      .primaryColor, // Dynamic text color
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isMonthly = false;
                      });
                    },
                    child: Center(
                      child: Text(
                        "DAILY",
                        style: TextStyleFont.button.copyWith(
                          color:
                              isMonthly
                                  ? DocvedaColors.primaryColor
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
