import 'package:docveda_app/common/widgets/card/card.dart';
import 'package:docveda_app/common/widgets/layouts/grid_layout.dart';
import 'package:docveda_app/features/clinic/screens/discount/discountScreen.dart';
import 'package:docveda_app/features/clinic/screens/refund/refundScreen.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/helpers/format_amount.dart';
import 'package:docveda_app/utils/theme/custom_themes/text_style_font.dart';
import 'package:flutter/material.dart';

class ExpensesSection extends StatelessWidget {
  final List<Map<String, dynamic>> expenseDataArray;
  final bool isSelectedMonthly;
  final DateTime prevSelectedDate;

  const ExpensesSection({
    Key? key, 
    required this.expenseDataArray,
    required this.isSelectedMonthly,
    required this.prevSelectedDate
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DocvedaGridLayout(
      itemCount: expenseDataArray.length,
      itemBuilder: (_, index) {
        final label = expenseDataArray[index]['label'] ?? "N/A";

        return GestureDetector(
          onTap: () {
            if (label.toLowerCase().contains('discount')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DiscountsScreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,), // Navigate to DiscountsScreen
                ),
              );
            } else if (label.toLowerCase().contains('refund')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RefundsScreen(isSelectedMonthly: isSelectedMonthly, prevSelectedDate: prevSelectedDate,), // Navigate to RefundsScreen
                ),
              );
            }
            // Add more conditions for other labels if needed
          },
          child: DocvedaCard(
            child: Padding(
              padding: const EdgeInsets.only(left: DocvedaSizes.xs),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyleFont.dashboardcard,
                    ),
                    Text(
                      FormatAmount.formatAmount(
                          expenseDataArray[index]['value']),
                      style: TextStyleFont.subheading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
