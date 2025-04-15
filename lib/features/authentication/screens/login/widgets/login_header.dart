import 'package:docveda_app/common/widgets/app_text/app_text.dart';
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
          height: 60,
          width: double.infinity,
          fit: BoxFit
              .contain, // Use BoxFit.cover if you want it to fill the space
          image: AssetImage(
            dark ? DocvedaImages.darkAppLogo : DocvedaImages.darkAppLogo,
          ),
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
