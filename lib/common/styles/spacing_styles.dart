
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DocvedaSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: DocvedaSizes.appBarHeight,
    left: DocvedaSizes.defaultSpace,
    bottom: DocvedaSizes.defaultSpace,
    right: DocvedaSizes.defaultSpace
  );
}