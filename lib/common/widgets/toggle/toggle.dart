import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:flutter/material.dart';

class DocvedaToggle extends StatefulWidget {
  final bool? isMonthly;
  final Function(bool)? onToggle;

  const DocvedaToggle({
    super.key,
    this.isMonthly,
    this.onToggle,
  });

  @override
  State<DocvedaToggle> createState() => _DocvedaToggleState();
}

class _DocvedaToggleState extends State<DocvedaToggle> {
  late bool isMonthly;

  @override
  void initState() {
    super.initState();
    isMonthly = widget.isMonthly ?? false;
  }

  void _toggle(bool value) {
    setState(() {
      isMonthly = value;
      if (widget.onToggle != null) {
        widget.onToggle!(isMonthly);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
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
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: isMonthly ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggle(true),
                  child: Center(
                    child: DocvedaText(
                      text: "MONTHLY",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isMonthly ? Colors.white : Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _toggle(false),
                  child: Center(
                    child: DocvedaText(
                      text: "DAILY",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isMonthly ? Colors.purple : Colors.white,
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
  }
}
