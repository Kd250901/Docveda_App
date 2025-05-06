import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/common/widgets/layouts/grid_layout.dart';
import 'package:docveda_app/features/clinic/screens/depositScreen/depositsScreen.dart';
import 'package:docveda_app/features/clinic/screens/ipdSettlement/ipdSettlementsScreen.dart';
import 'package:docveda_app/features/clinic/screens/opdBills/opdBillsScreen.dart';
import 'package:docveda_app/features/clinic/screens/opdPayment/opdPaymentScreen.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/format_amount.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RevenueSection extends StatelessWidget {
  final List<Map<String, dynamic>> revenueDataArray;
  final bool isSelectedMonthly;
  final DateTime prevSelectedDate;

  const RevenueSection({Key? key, required this.revenueDataArray, required this.isSelectedMonthly,
    required this.prevSelectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocvedaGridLayout(
      itemCount: revenueDataArray.length,
      itemBuilder: (_, index) {
        final label = revenueDataArray[index]['label']?.toLowerCase() ?? '';

        // Map of keywords to corresponding screens
        final Map<String, Widget Function()> revenueScreens = {
          'deposit': () => DepositScreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,),
          'opd payment': () => Opdpaymentscreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,),
          'opd bill': () => Opdbillsscreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,),
          'ipd settlement': () => IPDSettlementScreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,),
        };

        return GestureDetector(
          onTap: () {
            for (final key in revenueScreens.keys) {
              if (label.contains(key)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => revenueScreens[key]!(),
                  ),
                );
                break;
              }
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
                  const SizedBox(width: DocvedaSizes.spaceBtwItemsS),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          revenueDataArray[index]['label'] ?? "N/A",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleFont.dashboardcard,
                        ),
                        Text(
                          FormatAmount.formatAmount(
                            revenueDataArray[index]['value'],
                          ).toString(),
                          style: TextStyleFont.subheading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
