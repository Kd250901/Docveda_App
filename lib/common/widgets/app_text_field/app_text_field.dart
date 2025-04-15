import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocvedaTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final InputDecoration? customDecoration;

  const DocvedaTextFormField({
    super.key,
    this.controller,
    this.label = '',
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.inputFormatters,
    this.style,
    this.customDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      style: style,
      decoration: customDecoration ??
          InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            labelText: label.isNotEmpty ? label : null,
            border: const OutlineInputBorder(),
            suffixIcon: suffixIcon,
          ),
    );
  }
}
