import 'package:flutter/material.dart';

class TextStyleFont {
  static const TextStyle heading = TextStyle(
    fontFamily: "Manrope",
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: "Manrope",
    fontSize: 16, // Updated to 16px
    fontWeight: FontWeight.w700, // Updated to 800
  );

  static const TextStyle body = TextStyle(
    fontFamily: "Manrope",
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle button = TextStyle(
    fontFamily: "Manrope",
    fontSize: 10,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: "Manrope",
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle dashboardcard = TextStyle(
    fontFamily: "Manrope",
    fontSize: 12, // Updated to 16px
    fontWeight: FontWeight.w600, // Updated to 800
  );

  static var title;
}
