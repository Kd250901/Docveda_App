import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sales Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 200, child: _buildPieChart()),

            const SizedBox(height: 20),
            const Text(
              "Revenue Growth",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 200, child: _buildLineChart()),
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
          PieChartSectionData(value: 40, color: Colors.blue, title: '40%'),
          PieChartSectionData(value: 30, color: Colors.red, title: '30%'),
          PieChartSectionData(value: 20, color: Colors.green, title: '20%'),
          PieChartSectionData(value: 10, color: Colors.orange, title: '10%'),
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
            color: Colors.deepPurple,
            barWidth: 4,
          ),
        ],
      ),
    );
  }
}
