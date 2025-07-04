import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:indisk_app/utils/global_variables.dart';
import '../../../../api_service/models/salep_graph_master.dart';
import 'owner_home_view_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final OwnerHomeViewModel mViewModel = OwnerHomeViewModel();
  String? timePeriod = "monthly";
  String? graphType = "Sales Summary";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      await Future.wait([
        // mViewModel.getOwnerHomeApi(),
        mViewModel.salesCountApi(
          ownerId: gLoginDetails!.sId.toString(),
        ),
        if (graphType != null && graphType!.isNotEmpty)
          mViewModel.salesGraphApi(
            ownerId: gLoginDetails!.sId.toString(),
            graphType: graphType!,
            timePeriod: timePeriod ?? "",
          ),
      ]);
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatCard(
                      "Gross sales",
                      "kr.${mViewModel.salesCountData?.grossSales ?? ""}",
                      Colors.green),
                  _buildStatCard(
                      "Refunds",
                      "kr.${mViewModel.salesCountData?.refunds ?? ""}",
                      Colors.grey),
                  _buildStatCard(
                      "Discounts",
                      "kr.${mViewModel.salesCountData?.totalDiscount ?? ""}",
                      Colors.red),
                  _buildStatCard(
                      "Net sales",
                      "kr.${mViewModel.salesCountData?.netSales ?? ""}",
                      Colors.green),
                  _buildStatCard(
                      "Gross profit",
                      "kr.${mViewModel.salesCountData?.grossProfit ?? ""}",
                      Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimePeriodButton("Monthly", "monthly"),
                  _buildTimePeriodButton("Yearly", "yearly"),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 250,
                    child: mViewModel.isSalesGraphApiLoading
                        ? const Center(child: CircularProgressIndicator())
                        : mViewModel.salesGraph == null ||
                                mViewModel.salesGraph!.isEmpty
                            ? Center(
                                child: Text(
                                  graphType == null
                                      ? "Select a report type"
                                      : "No data available",
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: true),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        interval: _calculateInterval(
                                            mViewModel.salesGraph),
                                        getTitlesWidget: (value, meta) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 4.0),
                                            child: Text(
                                              'kr.${value.toInt()}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          final labels = _generateDateLabels(
                                              mViewModel.salesGraph);
                                          final index = value.toInt();
                                          if (index >= 0 &&
                                              index < labels.length) {
                                            return Text(
                                              labels[index],
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _convertApiDataToFlSpots(
                                          mViewModel.salesGraph),
                                      isCurved: true,
                                      color: Colors.green,
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: true),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.green.withOpacity(0.3),
                                      ),
                                    ),
                                  ],
                                  minY: 0,
                                  maxY: _calculateMaxY(mViewModel.salesGraph),
                                  lineTouchData: LineTouchData(enabled: true),
                                ),
                              ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 2,
                children: reportItems.map((item) {
                  return _buildReportCard(
                    context,
                    item['title'],
                    item['icon'],
                    item['color'],
                    item['graphType'],
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePeriodButton(String label, String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          timePeriod = period;
        });
        loadData();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: timePeriod == period ? Colors.blue : Colors.grey[200],
        foregroundColor: timePeriod == period ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  double _calculateMaxY(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return 1000;
    final maxTotal = data.fold<double>(
        0,
        (prev, item) => item.total != null && item.total! > prev
            ? item.total!.toDouble()
            : prev);
    return maxTotal * 1.2; // Add 20% padding
  }

  double _calculateInterval(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return 500;
    final maxTotal = data.fold<double>(
        0,
        (prev, item) => item.total != null && item.total! > prev
            ? item.total!.toDouble()
            : prev);
    if (maxTotal <= 1000) return 200;
    if (maxTotal <= 5000) return 1000;
    if (maxTotal <= 10000) return 2000;
    return 5000;
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
    String graphType,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          this.graphType = graphType;
        });
        loadData();
      },
      child: Card(
        elevation: this.graphType == graphType ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: this.graphType == graphType
              ? BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
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
                child: Icon(icon, size: 24, color: color),
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

  List<FlSpot> _convertApiDataToFlSpots(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return [];

    // Sort by date
    data.sort((a, b) {
      final dateA = DateTime.tryParse(a.sId ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.sId ?? '') ?? DateTime(1970);
      return dateA.compareTo(dateB);
    });

    return data.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.total ?? 0.0,
      );
    }).toList();
  }

  List<String> _generateDateLabels(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return [];

    // Sort by date (same as above)
    data.sort((a, b) {
      final dateA = DateTime.tryParse(a.sId ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b.sId ?? '') ?? DateTime(1970);
      return dateA.compareTo(dateB);
    });

    return data.map((item) {
      final date = DateTime.tryParse(item.sId ?? '');
      return date != null
          ? "${date.day}/${date.month}" // Format as "24/6"
          : item.sId ?? "";
    }).toList();
  }

  final List<Map<String, dynamic>> reportItems = [
    {
      'title': 'Sales Summary',
      'icon': Icons.summarize,
      'color': Colors.blue,
      'graphType': 'Sales Summary',
    },
    {
      'title': 'Sales by Item',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
      'graphType': 'Sales by Item',
    },
    {
      'title': 'Sales by Category',
      'icon': Icons.category,
      'color': Colors.orange,
      'graphType': 'Sales by Category',
    },
  ];
}
