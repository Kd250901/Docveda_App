import 'package:docveda_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class DocvedaPrimaryHeaderContainer extends StatelessWidget {
  const DocvedaPrimaryHeaderContainer({
    super.key,
    required this.child
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DocvedaCurvedEdgesWidget(
      child: Container(
        color: DocvedaColors.primaryColor,
        height: DocvedaHelperFunctions.screenHeight() * 0.3,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            child
          ],
        ),
      ),);
  }
}