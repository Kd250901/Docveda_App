import 'package:flutter/material.dart';

import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/text_theme.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/outlined_button_theme.dart';

class DocvedaAppTheme {
  DocvedaAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      textTheme: DocvedaTextTheme.lightTextTheme,
      chipTheme: DocvedaChipTheme.lightChipTheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: DocvedaAppBarTheme.lightAppBarTheme,
      checkboxTheme: DocvedaCheckboxTheme.lightCheckboxTheme,
      bottomSheetTheme: DocvedaBottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: DocvedaElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: DocvedaOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme:
          DocvedaTextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: DocvedaTextTheme.darkTextTheme,
      chipTheme: DocvedaChipTheme.darkChipTheme,
      appBarTheme: DocvedaAppBarTheme.darkAppBarTheme,
      checkboxTheme: DocvedaCheckboxTheme.darkCheckboxTheme,
      bottomSheetTheme: DocvedaBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: DocvedaElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: DocvedaOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: DocvedaTextFormFieldTheme.darkInputDecorationTheme);
}
