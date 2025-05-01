import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Owner Dashboard"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPieChartCard(),
              kSizedBoxV10,
              BeautifulOrderSummaryTable(),
              kSizedBoxV10,
              TimeSlotGrid(),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildPieChartCard() {
    return Card(
      elevation: 2,
      color: CommonColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            children: [
              Container(
                height: 240.0,
                width: kDeviceWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Order Type Share",
                            style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 16),
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                    value: 40,
                                    title: 'Dine-in',
                                    color: Colors.blue,
                                    radius: 50),
                                PieChartSectionData(
                                    value: 35,
                                    title: 'Delivery',
                                    color: Colors.green,
                                    radius: 50),
                                PieChartSectionData(
                                    value: 25,
                                    title: 'Take-away',
                                    color: Colors.orange,
                                    radius: 50),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    kSizedBoxH20,
                    kSizedBoxH20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getChartBlock(
                            blockColor: CommonColors.green, text: "Delivery"),
                        kSizedBoxV20,
                        getChartBlock(
                            blockColor: CommonColors.orange, text: "Take Away"),
                        kSizedBoxV20,
                        getChartBlock(
                            blockColor: CommonColors.blue , text: "Drive In")
                      ],
                    ),
                    Spacer(),
                    Card(
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100.0,
                              width: 135.0,
                              child: Column(
                                children: [
                                  Text("Total Orders",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Text("250",
                                      style: getBoldTextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontColor: CommonColors.green,
                                        fontSize: 30.0
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: 100.0,
                              width: 135.0,
                              child: Column(
                                children: [
                                  Text("Total Revenue",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8),
                                  Text("\$2500",
                                      style: getBoldTextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontColor: CommonColors.green,
                                          fontSize: 30.0
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              kSizedBoxV20,

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderRevenue() {
    final timeSlots = [
      "10-11",
      "11-12",
      "12-13",
      "13-14",
      "14-15",
      "15-16",
      "16-17",
      "17-18",
      "18-19",
      "19-20",
      "20-21",
      "21-22",
      "22-23"
    ];
    return ListView.separated(
      itemCount: timeSlots.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text("Time: ${timeSlots[index]}",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Orders: -- | Revenue: --"),
            trailing: Icon(Icons.arrow_forward_ios, size: 14),
          ),
        );
      },
    );
  }



  getChartBlock({required Color blockColor, required String text}) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 30.0,
            width: 50.0,
            color: blockColor,
          ),
          kSizedBoxH10,
          Text(
            text,
            style: getNormalTextStyle(),
          )
        ],
      ),
    );
  }
}



class BeautifulOrderSummaryTable extends StatelessWidget {
  final Map<String, Map<String, dynamic>> data = {
    "Dine-in": {"orders": 124, "revenue": 10500},
    "Delivery": {"orders": 98, "revenue": 8750},
    "Take-away": {"orders": 74, "revenue": 6200},
  };

  @override
  Widget build(BuildContext context) {
    TextStyle? headerStyle = getBoldTextStyle(
      fontSize: 16.0,
      fontColor: CommonColors.black
    );
    TextStyle? rowLabelStyle = getSemiBoldTextStyle(
      fontSize: 15.0
    );
    TextStyle? valueStyle = getNormalTextStyle(
      fontSize: 15.0
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Summary", style: getMediumTextStyle()),
            const SizedBox(height: 20),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    const SizedBox(), // Empty top-left cell
                    Center(child: Text("Dine-in", style: headerStyle)),
                    Center(child: Text("Delivery", style: headerStyle)),
                    Center(child: Text("Take-away", style: headerStyle)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("Orders", style: rowLabelStyle),
                    ),
                    Center(child: Text("${data["Dine-in"]!["orders"]}", style: valueStyle)),
                    Center(child: Text("${data["Delivery"]!["orders"]}", style: valueStyle)),
                    Center(child: Text("${data["Take-away"]!["orders"]}", style: valueStyle)),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text("Revenue", style: rowLabelStyle),
                    ),
                    Center(child: Text("₹${data["Dine-in"]!["revenue"]}", style: valueStyle)),
                    Center(child: Text("₹${data["Delivery"]!["revenue"]}", style: valueStyle)),
                    Center(child: Text("₹${data["Take-away"]!["revenue"]}", style: valueStyle)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class TimeSlotGrid extends StatelessWidget {
  final List<Map<String, dynamic>> timeSlots = [
    {"time": "10-11", "orders": 12, "revenue": 1500},
    {"time": "11-12", "orders": 15, "revenue": 1900},
    {"time": "12-13", "orders": 20, "revenue": 2500},
    {"time": "13-14", "orders": 10, "revenue": 1100},
    {"time": "14-15", "orders": 18, "revenue": 2300},
    {"time": "15-16", "orders": 16, "revenue": 2100},
    {"time": "16-17", "orders": 13, "revenue": 1750},
    {"time": "17-18", "orders": 14, "revenue": 1600},
    {"time": "18-19", "orders": 19, "revenue": 2700},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: timeSlots.map((slot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Time: ${slot['time']}", style: getBoldTextStyle(
                fontSize: 16.0
              )),
              kSizedBoxV10,
              Divider(color: CommonColors.grey100,height: 1.0,),
              const SizedBox(height: 4),
              Text("Orders",style: getBoldTextStyle(
                fontSize: 15.0,
                fontColor: CommonColors.black
              ),),
              kSizedBoxV5,
              Text("${slot['orders']}",style: getSemiBoldTextStyle(
                  fontSize: 18.0,
                  fontColor: CommonColors.blue
              ),),
              Text("Revenue",style: getBoldTextStyle(
                fontSize: 15.0,
                fontColor: CommonColors.black
              ),),
              kSizedBoxV5,
              Text("\$${slot['revenue']}",style: getSemiBoldTextStyle(
                  fontSize: 18.0,
                  fontColor: CommonColors.green
              ),),
            ],
          ),
        );
      }).toList(),
    );
  }
}



