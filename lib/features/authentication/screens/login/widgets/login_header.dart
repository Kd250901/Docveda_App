import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocvedaLoginHeader extends StatelessWidget {
  const DocvedaLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DocvedaHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SvgPicture.asset(
        //   dark ? DocvedaImages.darkAppLogo : DocvedaImages.darkAppLogo,
        //   height: DocvedaSizes.imgHeightMd,
        //   width: double.infinity,
        //   fit: BoxFit.contain,
        // ),
        Image.asset(
          DocvedaImages.darkAppLogo,
          height: DocvedaSizes.imgHeightMd, // Adjust size as needed
          width: double.infinity,
        ),
        const SizedBox(height: DocvedaSizes.lg),
        // DocvedaText(
        //   text: "Welcome back,",
        //   style: Theme.of(context).textTheme.headlineMedium,
        // ),
        const SizedBox(height: DocvedaSizes.sm),
        // Text("Login Desc", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
