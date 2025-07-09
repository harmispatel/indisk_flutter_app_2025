import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_table_view_model.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';
import 'select_product/staff_select_product_view.dart';

class SelectTableView extends StatefulWidget {
  const SelectTableView({super.key});

  @override
  State<SelectTableView> createState() => _SelectTableViewState();
}

class _SelectTableViewState extends State<SelectTableView> {
  int? selectedTable;
  late SelectTableViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getTable();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<SelectTableViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Table To Order",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: PrimaryButton(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: CommonColors.primaryColor.withOpacity(0.8),
                height: 35,
                text: 'Take away',
                onPressed: () {
                  navigateToOrderScreen(
                      tableNo: 'Take away order');
                }),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final int crossAxisCount = 4;
          // final crossAxisCount = screenWidth > 1200
          //     ? 4
          //     : screenWidth > 800
          //         ? 3
          //         : 2;
          final spacing = 16.0;
          final totalSpacing = spacing * (crossAxisCount - 1);
          final itemWidth = (screenWidth - totalSpacing) / crossAxisCount;
          final itemHeight = 180;
          final aspectRatio = itemWidth / itemHeight;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
            children: List.generate(
              mViewModel.tablesList.length,
              (index) {
                final tableNumber = index + 1;
                return GestureDetector(
                  onTap: () {
                    navigateToOrderScreen(
                        tableNo:
                            mViewModel.tablesList[index].tableNo.toString(),
                        );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedTable == tableNumber
                          ? CommonColors.primaryColor.withOpacity(0.2)
                          : mViewModel.tablesList[index].available == true
                              ? Colors.white
                              : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (mViewModel.tablesList[index].orderTime != null)
                          SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: getOrderStatusColor(
                                    mViewModel.tablesList[index].orderStatus ??
                                        '',
                                  ),
                                ),
                                child: Text(
                                  mViewModel.tablesList[index].orderStatus ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CommonColors.white,
                                  ),
                                ),
                              ),
                              Text(
                                mViewModel.tablesList[index].orderTime ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedTable == tableNumber
                                      ? CommonColors.primaryColor
                                      : Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        mViewModel.tablesList[index].orderStatus == "Preparing"
                            ? Center(
                                child: Image.asset(
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.fill,
                                    LocalImages.food_preparing_view),
                              )
                            : mViewModel.tablesList[index].orderStatus ==
                                    "Prepared"
                                ? Center(
                                    child: Image.asset(
                                        height: 100,
                                        width: 150,
                                        fit: BoxFit.fill,
                                        LocalImages.img_waiter),
                                  )
                                : mViewModel.tablesList[index].orderStatus ==
                                        "Delivered"
                                    ? Center(
                                        child: Image.asset(
                                          LocalImages.img_people_dining,
                                          height: 100,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                    : Center(
                                        child: Image.asset(
                                          LocalImages.img_table,
                                          height: 100,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                        if (mViewModel.tablesList[index].orderedItemsCount !=
                            0) ...[
                          kSizedBoxV5,
                          Center(
                            child: Text(
                              'Ordered ${mViewModel.tablesList[index].orderedItemsCount} items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                height: 1,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 3),
                        Center(
                          child: Text(
                            'Table ${mViewModel.tablesList[index].tableNo}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedTable == tableNumber
                                  ? CommonColors.primaryColor
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'preparing':
        return CommonColors.red;
      case 'prepared':
        return CommonColors.orange;
      case 'delivered':
        return CommonColors.green;
      case 'idle':
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  void navigateToOrderScreen({required String tableNo}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            StaffSelectProductView(tableNo: tableNo),
      ),
    )
        .then((_) {
      mViewModel.getTable();
    });
  }
}
