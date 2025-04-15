import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AdmissionScreen extends StatefulWidget {
  const AdmissionScreen({super.key});

  @override
  _AdmisssionScreenState createState() => _AdmisssionScreenState();
}

class _AdmisssionScreenState extends State<AdmissionScreen> {
  final List<Map<String, String>> patients = [
    {
      "name": "Vedant Kulkarni",
      "age": "24 Years Old",
      "gender": "Male",
      "admission": "9th Feb, 25",
      "discharge": "13th Feb, 25",
      "finalSettlement": "₹2,40,000",
    },
    {
      "name": "Vedant Kulkarni",
      "age": "24 Years Old",
      "gender": "Male",
      "admission": "9th Feb, 25",
      "discharge": "13th Feb, 25",
      "finalSettlement": "₹2,40,000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DocvedaPrimaryHeaderContainer(
              child: Column(
                children: [
                  DocvedaAppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: DocvedaColors.white,
                              child: Image.asset(DocvedaImages.clinicLogo),
                            ),
                            const SizedBox(width: DocvedaSizes.spaceBtwItems),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DocvedaTexts.clinicNameTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .apply(color: DocvedaColors.white),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      DocvedaImages.protectLogo,
                                      width: 20, // Set the width
                                      height: 20, // Set the height
                                      fit:
                                          BoxFit
                                              .contain, // Ensures the image fits well
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ), // Spacing between image and text
                                    Text(
                                      DocvedaTexts.logo,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(color: DocvedaColors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.setting_25,
                          color: DocvedaColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DocvedaSizes.spaceBtwItems),
                  DocvedaToggle(),
                  const SizedBox(height: DocvedaSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.arrow_left_2),
                        style: ButtonStyle(
                          iconColor: WidgetStateProperty.all(
                            Colors.white,
                          ), // Change icon color
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: DocvedaSizes.spaceBtwItems),
                      Text(
                        "11 Feb, 2025",
                        style: TextStyle(
                          color: DocvedaColors.textWhite,
                          fontSize: DocvedaSizes.fontSizeSm,
                        ),
                      ),
                      const SizedBox(width: DocvedaSizes.spaceBtwItems),
                      IconButton(
                        icon: const Icon(Iconsax.arrow_right_3),
                        style: ButtonStyle(
                          iconColor: WidgetStateProperty.all(
                            Colors.white,
                          ), // Change icon color
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
