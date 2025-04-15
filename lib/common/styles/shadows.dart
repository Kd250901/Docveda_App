import 'package:docveda_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class DocvedaShadowStyle {

  static final horizontalShadow = BoxShadow(
    color: DocvedaColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
}