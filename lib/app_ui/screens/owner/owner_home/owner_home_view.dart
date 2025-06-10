import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/owner/owner_home/sales_summary/sales_summary_view.dart';
import 'owner_home_view_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

  final List<Map<String, dynamic>> reportItems = [
    {
      'title': 'Sales Summary',
      'icon': Icons.summarize,
      'color': Colors.blue,
      'screen': SalesSummaryView(),
    },
    {
      'title': 'Sales by Item',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Sales by Item')),
        body: Center(child: Text('Sales by Item Content')),
      ),
    },
    {
      'title': 'Sales by Category',
      'icon': Icons.category,
      'color': Colors.orange,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Sales by Category')),
        body: Center(child: Text('Sales by Category Content')),
      ),
    },
    // Add other report items with their respective screens...
    {
      'title': 'Sales by Employee',
      'icon': Icons.people,
      'color': Colors.purple,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Sales by Employee')),
        body: Center(child: Text('Sales by Employee Report Content')),
      ),
    },
    {
      'title': 'Sales by Payment',
      'icon': Icons.payment,
      'color': Colors.teal,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Sales by Payment')),
        body: Center(child: Text('Sales by Payment Report Content')),
      ),
    },
    {
      'title': 'Receipts',
      'icon': Icons.receipt,
      'color': Colors.indigo,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Receipts')),
        body: Center(child: Text('Receipts Report Content')),
      ),
    },
    {
      'title': 'Sales by Modifier',
      'icon': Icons.tune,
      'color': Colors.pink,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Sales by Modifier')),
        body: Center(child: Text('Sales by Modifier Report Content')),
      ),
    },
    {
      'title': 'Taxes',
      'icon': Icons.account_balance,
      'color': Colors.brown,
      'screen': Scaffold(
        appBar: AppBar(title: Text('Taxes')),
        body: Center(child: Text('Taxes Report Content')),
      ),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards Row
              Row(
                children: [
                  _buildStatCard("Gross sales", "kr. 104.235,00", Colors.green),
                  _buildStatCard("Refunds", "kr. 0,00", Colors.grey),
                  _buildStatCard("Discounts", "kr. 38.688,50", Colors.red),
                  _buildStatCard("Net sales", "kr. 65.546,50", Colors.green),
                  _buildStatCard("Gross profit", "kr. 41.688,50", Colors.green),
                ],
              ),
              const SizedBox(height: 24),
              // Sales Chart
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          drawHorizontalLine: true,
                          drawVerticalLine: false,
                        ),
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
                        )],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Reports Grid
              Text(
                'Sales Reports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
                children: reportItems.map((item) {
                  return _buildReportCard(
                    context,
                    item['title'],
                    item['icon'],
                    item['color'],
                    item['screen'],
                  );
                }).toList(),
              ),
            ],
          ),
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

  Widget _buildReportCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget screen,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 44, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}