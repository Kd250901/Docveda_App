import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(DocvedaTexts.analytics, style: TextStyle(color: DocvedaColors.white)),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              DocvedaTexts.salesOverview,
              style: TextStyle(fontSize: DocvedaSizes.fontSizeLg, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
            SizedBox(height: DocvedaSizes.pieChartHeight, child: _buildPieChart()),

            const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),
            const Text(
              DocvedaTexts.revenueGrowth,
              style: TextStyle(fontSize: DocvedaSizes.fontSizeLg, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
            SizedBox(height: DocvedaSizes.pieChartHeight, child: _buildLineChart()),
          ],
        ),
      ),
    );
  }

  /// Pie Chart
  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: DocvedaSizes.sec1, color: DocvedaColors.buttonPrimary, title: '40%'),
          PieChartSectionData(value: DocvedaSizes.sec2, color: DocvedaColors.error, title: '30%'),
          PieChartSectionData(value: DocvedaSizes.sec3, color: DocvedaColors.success, title: '20%'),
          PieChartSectionData(value: DocvedaSizes.sec4, color: DocvedaColors.warning, title: '10%'),
        ],
      ),
    );
  }

  /// Line Chart
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 3),
              const FlSpot(2, 2),
              const FlSpot(3, 4),
              const FlSpot(4, 3.5),
              const FlSpot(5, 4.5),
              const FlSpot(6, 4),
            ],
            isCurved: true,
            color: DocvedaColors.primaryColor,
            barWidth: DocvedaSizes.xs,
          ),
        ],
      ),
    );
  }
}
