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
                  navigateToOrderScreen(tableNo: 'Take away order');
                }),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: List.generate(
            mViewModel.tablesList.length,
            (index) {
              final tableNumber = index + 1;
              return GestureDetector(
                onTap: () {
                  navigateToOrderScreen(
                    tableNo: mViewModel.tablesList[index].tableNo.toString(),
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
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            mViewModel.tablesList[index].orderTime ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedTable == tableNumber
                                  ? CommonColors.primaryColor
                                  : Colors.grey[800],
                            ),
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
                      SizedBox(
                        height: 3,
                      ),
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
        ),
      ),
    );
  }

  void navigateToOrderScreen({required String tableNo}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => StaffSelectProductView(tableNo: tableNo),
      ),
    )
        .then((_) {
      mViewModel.getTable();
    });
  }
}
