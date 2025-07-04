// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// import '../owner_home_view_model.dart';
//
// class SalesSummaryView extends StatefulWidget {
//   final String? graphType;
//   const SalesSummaryView({this.graphType, super.key});
//
//   @override
//   State<SalesSummaryView> createState() => _SalesSummaryViewState();
// }
//
// class _SalesSummaryViewState extends State<SalesSummaryView> {
//   OwnerHomeViewModel? mViewModel;
//
//   String? timePeriod = "monthly";
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       print("sdffdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfds");
//       mViewModel?.getOwnerHomeApi();
//       mViewModel?.salesGraphApi(
//           ownerId: "6835a8126e3a346c632b878d",
//           graphType: widget.graphType ?? "",
//           timePeriod: timePeriod ?? "");
//     });
//   }
//
//   final List<FlSpot> salesData = [
//     FlSpot(0, 0),
//     FlSpot(1, 0),
//     FlSpot(2, 0),
//     FlSpot(3, 0),
//     FlSpot(4, 0),
//     FlSpot(5, 0),
//     FlSpot(6, 0),
//     FlSpot(7, 1000),
//     FlSpot(8, 500),
//     FlSpot(9, 3000),
//     FlSpot(10, 6000),
//     FlSpot(11, 9000),
//     FlSpot(12, 12000),
//     FlSpot(13, 10000),
//     FlSpot(14, 8000),
//     FlSpot(15, 9000),
//     FlSpot(16, 0),
//   ];
//
//   final List<String> dateLabels = [
//     "Apr 23",
//     "Apr 24",
//     "Apr 25",
//     "Apr 26",
//     "Apr 27",
//     "Apr 28",
//     "Apr 29",
//     "May 10",
//     "May 11",
//     "May 12",
//     "May 13",
//     "May 14",
//     "May 15",
//     "May 16",
//     "May 17",
//     "May 18",
//     "May 22"
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sales Dashboard"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStatCard("Gross sales", "kr. 104.235,00", Colors.green),
//                 _buildStatCard("Refunds", "kr. 0,00", Colors.grey),
//                 _buildStatCard("Discounts", "kr. 38.688,50", Colors.red),
//                 _buildStatCard("Net sales", "kr. 65.546,50", Colors.green),
//                 _buildStatCard("Gross profit", "kr. 41.688,50", Colors.green),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: Card(
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(
//                         drawHorizontalLine: true,
//                         drawVerticalLine: false,
//                       ),
//                       borderData: FlBorderData(show: true),
//                       titlesData: FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             reservedSize: 50,
//                             interval: 5000,
//                             getTitlesWidget: (value, meta) {
//                               return Text(
//                                 'kr.${(value / 1000).toStringAsFixed(0)}k',
//                                 style: TextStyle(fontSize: 12),
//                               );
//                             },
//                           ),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(
//                             showTitles: true,
//                             interval: 1,
//                             getTitlesWidget: (value, meta) {
//                               int index = value.toInt();
//                               if (index >= 0 && index < dateLabels.length) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 6.0),
//                                   child: Text(
//                                     dateLabels[index],
//                                     style: TextStyle(fontSize: 10),
//                                   ),
//                                 );
//                               }
//                               return Text('');
//                             },
//                           ),
//                         ),
//                         rightTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                         topTitles: AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                       ),
//                       minY: 0,
//                       maxY: 15000,
//                       lineBarsData: [
//                         LineChartBarData(
//                           isCurved: true,
//                           color: Colors.green,
//                           barWidth: 3,
//                           spots: salesData,
//                           dotData: FlDotData(show: true),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Colors.green.withOpacity(0.3),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, Color color) {
//     return Expanded(
//       child: Card(
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontSize: 14, color: Colors.grey)),
//               const SizedBox(height: 6),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:indisk_app/api_service/models/salep_graph_master.dart';

import '../owner_home_view_model.dart';

class SalesSummaryView extends StatefulWidget {
  final String? graphType;
  const SalesSummaryView({this.graphType, super.key});

  @override
  State<SalesSummaryView> createState() => _SalesSummaryViewState();
}

class _SalesSummaryViewState extends State<SalesSummaryView> {
  final OwnerHomeViewModel mViewModel = OwnerHomeViewModel();
  String? timePeriod = "monthly";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    await mViewModel.getOwnerHomeApi();
    await mViewModel.salesGraphApi(
      ownerId: "6835a8126e3a346c632b878d",
      graphType: widget.graphType ?? "",
      timePeriod: timePeriod ?? "",
    );
    setState(() {}); // Refresh UI after data is loaded
  }

  List<FlSpot> _convertApiDataToFlSpots(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return [FlSpot(0, 0)];

    // Sort data by date
    data.sort((a, b) => (a.sId ?? "").compareTo(b.sId ?? ""));

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return FlSpot(index.toDouble(), item.total?.toDouble() ?? 0);
    }).toList();
  }

  List<String> _generateDateLabels(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return ["No data"];

    // Sort data by date
    data.sort((a, b) => (a.sId ?? "").compareTo(b.sId ?? ""));

    return data.map((item) {
      final date = item.sId ?? "";
      // Format date as needed (e.g., "Jun 24")
      if (date.length >= 10) {
        return "${date.substring(5, 7)}/${date.substring(8, 10)}";
      }
      return date;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your stat cards here...

            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: mViewModel.isApiLoading
                      ? const Center(child: CircularProgressIndicator())
                      : mViewModel.salesGraph == null
                      ? const Center(child: Text("No data available"))
                      : LineChart(
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
                            interval: _calculateInterval(
                                mViewModel.salesGraph),
                            getTitlesWidget: (value, meta) {
                              return Text(
                                'kr.${value.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final labels = _generateDateLabels(
                                  mViewModel.salesGraph);
                              int index = value.toInt();
                              if (index >= 0 && index < labels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    labels[index],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      minY: 0,
                      maxY: _calculateMaxY(mViewModel.salesGraph),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 3,
                          spots: _convertApiDataToFlSpots(
                              mViewModel.salesGraph),
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

  double _calculateMaxY(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return 1000;
    final maxTotal = data.fold<double>(0, (prev, item) =>
    item.total != null && item.total! > prev ? item.total!.toDouble() : prev);
    return maxTotal * 1.2; // Add 20% padding
  }

  double _calculateInterval(List<SalesGraphData>? data) {
    if (data == null || data.isEmpty) return 500;
    final maxTotal = data.fold<double>(0, (prev, item) =>
    item.total != null && item.total! > prev ? item.total!.toDouble() : prev);
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
}
