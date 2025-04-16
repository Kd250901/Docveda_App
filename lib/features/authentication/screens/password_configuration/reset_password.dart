import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DocvedaSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(DocvedaImages.darkAppLogo),
                height: DocvedaSizes.imgHeightLs,
              ),
              // const SizedBox(height: DocvedaSizes.spaceBtwSections,),

              // Title & Subtitle
              DocvedaText(
                text: DocvedaTexts.resetPassword,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: DocvedaSizes.spaceBtwItems,
              ),
              DocvedaText(
                text: DocvedaTexts.resetPasswordDesc,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: DocvedaSizes.spaceBtwSections,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: const DocvedaText(text: DocvedaTexts.done)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
