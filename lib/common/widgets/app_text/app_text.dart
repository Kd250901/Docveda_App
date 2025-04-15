import 'package:flutter/material.dart';

class DocvedaText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const DocvedaText({
    super.key,
    required this.text,
    this.style,
    this.color,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium;

    return Text(
      text,
      style: defaultStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
