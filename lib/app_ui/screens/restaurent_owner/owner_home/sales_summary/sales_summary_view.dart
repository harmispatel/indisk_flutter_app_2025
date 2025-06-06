import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../owner_home_view_model.dart';

class SalesSummaryView extends StatefulWidget {
  const SalesSummaryView({super.key});

  @override
  State<SalesSummaryView> createState() => _SalesSummaryViewState();
}

class _SalesSummaryViewState extends State<SalesSummaryView> {
  OwnerHomeViewModel? mViewModel;

  final List<FlSpot> salesData = [
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
    FlSpot(7, 1000),
    FlSpot(8, 500),
    FlSpot(9, 3000),
    FlSpot(10, 6000),
    FlSpot(11, 9000),
    FlSpot(12, 12000),
    FlSpot(13, 10000),
    FlSpot(14, 8000),
    FlSpot(15, 9000),
    FlSpot(16, 0),
  ];

  final List<String> dateLabels = [
    "Apr 23",
    "Apr 24",
    "Apr 25",
    "Apr 26",
    "Apr 27",
    "Apr 28",
    "Apr 29",
    "May 10",
    "May 11",
    "May 12",
    "May 13",
    "May 14",
    "May 15",
    "May 16",
    "May 17",
    "May 18",
    "May 22"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Gross sales", "kr. 104.235,00", Colors.green),
                _buildStatCard("Refunds", "kr. 0,00", Colors.grey),
                _buildStatCard("Discounts", "kr. 38.688,50", Colors.red),
                _buildStatCard("Net sales", "kr. 65.546,50", Colors.green),
                _buildStatCard("Gross profit", "kr. 41.688,50", Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        drawHorizontalLine: true, drawVerticalLine: false,),
                      borderData: FlBorderData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            interval: 5000,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'kr.${(value / 1000).toStringAsFixed(0)}k',
                                style: TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < dateLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    dateLabels[index],
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      minY: 0,
                      maxY: 15000,
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          spots: salesData,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
