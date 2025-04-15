import 'package:docveda_app/common/widgets/appbar/appbar.dart';
import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:docveda_app/common/widgets/layouts/grid_layout.dart';
import 'package:docveda_app/common/widgets/section_heading/section_heading.dart';
import 'package:docveda_app/common/widgets/toggle/toggle.dart';
import 'package:docveda_app/features/clinic/screens/discharge/admissionScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/dischargeScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/opdPaymentScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/depositsScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/ipdSettlementsScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/widgets/opdBillsScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<String> dashboardItems = [
    DocvedaTexts.dashboardItems1, // "Admissions"
    DocvedaTexts.dashboardItems2, // "Discharges"
    DocvedaTexts.dashboardItems3, // "Bed Transfers"
    DocvedaTexts.dashboardItems4, // "OPD Bills"
    DocvedaTexts.dashboardItems5, // "OPD Payments"
    DocvedaTexts.dashboardItems6, // "Deposits"
    DocvedaTexts.dashboardItems7, // "IPD Settlements"
    DocvedaTexts.dashboardItems8, // "Discounts"
    DocvedaTexts.dashboardItems9, // "Refunds"
  ];

  final List<Widget> pages = [AdmissionScreen(''), Dischargescreen('')];

  @override
  Widget build(BuildContext context) {
    // final width = (MediaQuery.of(context).size.width);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                                      width:
                                          20, // Set the width as per your requirement
                                      height:
                                          20, // Set the height as per your requirement
                                      fit: BoxFit
                                          .contain, // Ensures the image fits well
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ), // Adds spacing between image and text
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
                  const SizedBox(height: 10), // Increased spacing before toggle
                  // Increased spacing
                  DocvedaToggle(),
                  const SizedBox(height: 10), // New spacing below toggle
                  // const SizedBox(height: DocvedaSizes.spaceBtwItems,),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Ensures the content is centered
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
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DocvedaSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // PATIENT INFORMATION
                  DocvedaSectionHeading(
                    title: 'PATIENT INFORMATION',
                    showActionButton: false,
                    textStyle: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 16, // Adjust as needed
                      fontWeight: FontWeight.bold, // Optional: Adjust weight
                      color: Colors.black, // Optional: Change color
                    ),
                  ),

                  const SizedBox(height: 20),
                  DocvedaGridLayout(
                    itemCount: pages.length,
                    itemBuilder: (_, index) => Material(
                      color:
                          Colors.transparent, // Ensures the ripple is visible
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => pages[index],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Matches your card shape
                        splashColor: Colors.blue.withOpacity(
                          0.2,
                        ), // Customize ripple color
                        child: SizedBox(
                          height: 200,
                          child: DocvedaCard(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.activity),
                                  const SizedBox(width: 10, height: 30),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dashboardItems[
                                            index], // Ensure this is valid and non-null
                                        style: TextStyleFont
                                            .dashboardcard, // Apply the custom text style
                                      ),
                                      Text(
                                        "2546",
                                        style: TextStyleFont
                                            .subheading, // Apply the custom text style
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  DocvedaCard(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.arrange_circle_2),
                            const SizedBox(width: 10),
                            Text(
                              "123",
                              style: TextStyle(
                                fontSize: DocvedaSizes
                                    .cardNumberSize, // Increase font size
                                fontWeight: FontWeight.bold, // Make text bold
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(DocvedaTexts.dashboardItems3),
                          ],
                        ),
                        Icon(Iconsax.arrow_right_3),
                      ],
                    ),
                  ),
                  const SizedBox(height: DocvedaSizes.spaceBtwItems),
                  DocvedaSectionHeading(
                    title: 'PATIENT INFORMATION',
                    showActionButton: false,
                    textStyle: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 16, // Adjust as needed
                      fontWeight: FontWeight.bold, // Optional: Adjust weight
                      color: Colors.black, // Optional: Change color
                    ),
                  ),

                  const SizedBox(height: DocvedaSizes.spaceBtwItems),
                  DocvedaGridLayout(
                    itemCount: 4,
                    itemBuilder: (_, index) => InkWell(
                      onTap: () {
                        if (dashboardItems[index + 3] ==
                            DocvedaTexts.dashboardItems5) {
                          // Navigate to the OPD Payments Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Opdpaymentscreen(), // Your target screen
                            ),
                          );
                        } else if (dashboardItems[index + 3] ==
                            DocvedaTexts.dashboardItems4) {
                          // Navigate to OPD Bills
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Opdbillsscreen(),
                            ),
                          );
                        } else if (index + 3 == 6) {
                          // IPD Settlements
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Ipdsettlementsscreen(),
                            ),
                          );
                        } else if (dashboardItems[index + 3] ==
                            DocvedaTexts.dashboardItems6) {
                          // Navigate to Deposits Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Depositsscreen(),
                            ),
                          );
                        }
                      },
                      child: DocvedaCard(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Iconsax.activity),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dashboardItems[index + 3],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyleFont.dashboardcard,
                                    ),
                                    Text(
                                      "\u{20B9}12,000",
                                      style: TextStyleFont.subheading,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: DocvedaSizes.spaceBtwItems),

                  // EXPENSES
                  DocvedaSectionHeading(
                    title: 'PATIENT INFORMATION',
                    showActionButton: false,
                    textStyle: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 16, // Adjust as needed
                      fontWeight: FontWeight.bold, // Optional: Adjust weight
                      color: Colors.black, // Optional: Change color
                    ),
                  ),

                  const SizedBox(height: DocvedaSizes.spaceBtwItems),
                  DocvedaGridLayout(
                    itemCount: 2,
                    itemBuilder: (_, index) => DocvedaCard(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dashboardItems[index + 7],
                                style: TextStyleFont.dashboardcard,
                              ), // Using dynamic list
                              Text(
                                "\u{20B9}4,700",
                                style: TextStyleFont.subheading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
