import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class DocvedaLoginHeader extends StatelessWidget {
  const DocvedaLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = DocvedaHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          height: 150,
          image: AssetImage(
            dark ? DocvedaImages.darkAppLogo : DocvedaImages.darkAppLogo,
          ),
        ),
        const SizedBox(height: DocvedaSizes.lg),
        Text(
          "Welcome back,",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: DocvedaSizes.sm),
        // Text("Login Desc", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
