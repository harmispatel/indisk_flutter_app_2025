import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/manager/manager_home/manager_home_view_model.dart';
import 'package:indisk_app/utils/global_variables.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ManagerHomeView extends StatefulWidget {
  const ManagerHomeView({super.key});

  @override
  State<ManagerHomeView> createState() => _ManagerHomeViewState();
}

class _ManagerHomeViewState extends State<ManagerHomeView> {
  final ManagerHomeViewModel mViewModel = ManagerHomeViewModel();
  String timePeriod = "monthly";
  String graphType = "Sales Summary";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await mViewModel.salesMangerGraphApi(
        managerId: gLoginDetails!.sId.toString(),
        graphType: graphType,
        timePeriod: timePeriod,
      );
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manager Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: mViewModel.isApiLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards Row
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  // Main Content Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (Food Items)
                      Expanded(
                        child: Column(
                          children: [
                            _buildFoodItemsCard(),
                            const SizedBox(height: 20),
                            _buildTimePeriodButtons(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right Column (Sales by Item)
                      Expanded(child: _buildSalesByItemCard()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Chart Section
                  _buildSalesChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
            "Gross sales",
            "kr.${mViewModel.salesCountData?.grossSales ?? "0.00"}",
            Colors.green),
        SizedBox(width: 10),
        _buildStatCard(
            "Discounts",
            "kr.${mViewModel.salesCountData?.totalDiscount ?? "0.00"}",
            Colors.red),
        SizedBox(width: 10),
        _buildStatCard(
            "Net sales",
            "kr.${mViewModel.salesCountData?.netSales ?? "0.00"}",
            Colors.green),
        SizedBox(width: 10),
        _buildStatCard(
            "Gross profit",
            "kr.${mViewModel.salesCountData?.grossProfit ?? "0.00"}",
            Colors.green),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
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

  Widget _buildFoodItemsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Food Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            if (mViewModel.foodies != null)
              ...mViewModel.foodies!
                  .map((food) => _buildFoodieItem(food))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodieItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimePeriodButton("Daily", "daily"),
        _buildTimePeriodButton("Week", "week"),
        _buildTimePeriodButton("Monthly", "monthly"),
        _buildTimePeriodButton("Yearly", "yearly"),
      ],
    );
  }

  Widget _buildTimePeriodButton(String label, String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          timePeriod = period;
          loadData();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: timePeriod == period ? Colors.blue : Colors.grey[200],
        foregroundColor: timePeriod == period ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildSalesByItemCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales by Item',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Quantity Sold',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            if (mViewModel.salesGraph != null &&
                mViewModel.salesGraph!.isNotEmpty)
              ...mViewModel.salesGraph!
                  .map(
                    (item) => _buildDishItem(
                      item.name ?? "Unknown",
                      "${item.totalQuantity ?? 0} sold",
                    ),
                  )
                  .toList()
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'No sales data available',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDishItem(String name, String quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            quantity,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Selling',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<SalesChartData, String>(
                    dataSource: [
                      SalesChartData('Day 1', 20000),
                      SalesChartData('Day 2', 15000),
                      SalesChartData('Day 3', 10000),
                      SalesChartData('Day 4', 5000),
                    ],
                    xValueMapper: (SalesChartData sales, _) => sales.day,
                    yValueMapper: (SalesChartData sales, _) => sales.amount,
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesChartData {
  final String day;
  final int amount;

  SalesChartData(this.day, this.amount);
}
