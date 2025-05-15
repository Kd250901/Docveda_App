import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/features/clinic/screens/bedTransferScreen/bedTransferScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BedTransferCard extends StatelessWidget {
  final int bedTransferCount;
  final bool isSelectedMonthly;
  final DateTime prevSelectedDate;

  const BedTransferCard(
      {Key? key,
      required this.bedTransferCount,
      required this.isSelectedMonthly,
      required this.prevSelectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocvedaCard(
      width: double.infinity,
      height: DocvedaSizes.cardHeightLg,
      child: GestureDetector(
        onTap: () {
          // Navigate to BedTransferScreen when tapped
          Get.to(() => BedTransferScreen(
                isSelectedMonthly: isSelectedMonthly,
                prevSelectedDate: prevSelectedDate,
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Iconsax.repeat),
                const SizedBox(width: DocvedaSizes.spaceBtwItemsS),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$bedTransferCount',
                        style: TextStyleFont.subheading.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: DocvedaSizes.fontSizeXlg),
                      ),
                      TextSpan(
                        text: ' Bed Transfer',
                        style: TextStyleFont.subheading.copyWith(
                            fontWeight: FontWeight.bold,
                            color: DocvedaColors.textTitle,
                            fontSize: DocvedaSizes.fontSizeLg),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Icon(Iconsax.arrow_right_3),
          ],
        ),
      ),
    );
  }
}
