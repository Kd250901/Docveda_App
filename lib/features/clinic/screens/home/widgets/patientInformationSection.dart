import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/common/widgets/layouts/grid_layout.dart';
import 'package:docveda_app/features/clinic/screens/admission/admissionScreen.dart';
import 'package:docveda_app/features/clinic/screens/discharge/dischargeScreen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PatientInformationSection extends StatelessWidget {
  final List<dynamic> patientDataArray;
  final bool isSelectedMonthly;
  final DateTime prevSelectedDate;

  const PatientInformationSection({Key? key, required this.patientDataArray, required this.isSelectedMonthly,
    required this.prevSelectedDate,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocvedaGridLayout(
      itemCount: patientDataArray.length,
      itemBuilder: (_, index) => Material(
        color: DocvedaColors.transparent,
        child: InkWell(
          onTap: () {
            if (index < patientDataArray.length) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return index == 0
                        ? AdmissionScreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,)
                        : Dischargescreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,);
                  },
                ),
              );
            } else {
              print(
                "Index $index is out of bounds for patientDataArray length ${patientDataArray.length}",
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: DocvedaColors.buttonPrimary.withOpacity(0.2),
          child: SizedBox(
            height: DocvedaSizes.pieChartHeight,
            child: DocvedaCard(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: DocvedaSizes.spaceBtwItemsS,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Iconsax.activity),
                    const SizedBox(width: DocvedaSizes.spaceBtwItemsS),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientDataArray[index]['label'] ?? "N/A",
                            style: TextStyleFont.dashboardcard.copyWith(
                              fontSize: DocvedaSizes.fontSize,
                            ),
                            softWrap: true,
                            maxLines: 2,
                          ),
                          const SizedBox(height: DocvedaSizes.xs),
                          Text(
                            patientDataArray[index]['value']?.toString() ?? '0',
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
      ),
    );
  }
}
