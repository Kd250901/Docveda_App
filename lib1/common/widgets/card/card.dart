import 'package:docveda_app/common/styles/shadows.dart';
import 'package:docveda_app/common/widgets/custom_shapes/curved_edges/rounded_container.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class DocvedaCard extends StatelessWidget {
  const DocvedaCard({super.key, this.width = 180, this.height = 98, required this.child});

  final Widget? child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {

    final dark = DocvedaHelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        boxShadow: [DocvedaShadowStyle.horizontalShadow],
        borderRadius: BorderRadius.circular(DocvedaSizes.cardRadius),
        color: DocvedaHelperFunctions.isDarkMode(context) ? DocvedaColors.darkerGrey : DocvedaColors.white,
      ),
      child: Column(
        children: [
          DocvedaRoundedContainer(
            height: height,
            padding: const EdgeInsets.all(DocvedaSizes.sm),
            backgroundColor: dark ? DocvedaColors.dark : DocvedaColors.light,
            showBorder: true,
            borderColor: DocvedaColors.primaryColor.withOpacity(0.1),
            child: child
          )
        ],
      ),
    );
    
  }
}