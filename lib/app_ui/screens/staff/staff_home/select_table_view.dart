import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_table_view_model.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
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
                        setState(() {
                          selectedTable = tableNumber;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedTable == tableNumber
                              ? CommonColors.primaryColor.withOpacity(0.2)
                              : mViewModel.tablesList[index].available == true ? Colors.green.shade100 : Colors.red.shade100,
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
                            Center(
                              child: Image.asset(
                                LocalImages.img_table,
                                height: 100,
                                width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                            if (mViewModel
                                    .tablesList[index].orderedItemsCount !=
                                0)
                              Center(
                                child: Text(
                                  'Ordered ${mViewModel.tablesList[index].orderedItemsCount} items',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
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
            if (selectedTable != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StaffSelectProductView(
                            tableNo: selectedTable.toString()),
                      ),
                    ).then((_){
                      mViewModel.getTable();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Order',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
