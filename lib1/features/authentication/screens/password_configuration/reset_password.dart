import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
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
          IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DocvedaSizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(image: const AssetImage(DocvedaImages.darkAppLogo), height: 150,),
              // const SizedBox(height: DocvedaSizes.spaceBtwSections,),

              // Title & Subtitle
              Text("Reset Password", style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center, ),
              const SizedBox(height: DocvedaSizes.spaceBtwItems,),
              Text("Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.", style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, ),
              const SizedBox(height: DocvedaSizes.spaceBtwSections,),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Get.back(), child: const Text("Done")),
              )

            ],
          ),
        ),
      ),
    );
  }
}