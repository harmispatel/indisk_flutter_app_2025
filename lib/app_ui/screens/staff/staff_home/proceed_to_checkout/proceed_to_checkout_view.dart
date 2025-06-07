import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:indisk_app/utils/local_images.dart';

import '../staff_home_view.dart';

class ProceedToCheckoutView extends StatefulWidget {
  const ProceedToCheckoutView({super.key});

  @override
  State<ProceedToCheckoutView> createState() => _ProceedToCheckoutViewState();
}

class _ProceedToCheckoutViewState extends State<ProceedToCheckoutView> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Table To Order", style: TextStyle(fontWeight: FontWeight.w500),),
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
                children: List.generate(13, (index) {
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
                            : Colors.grey[200],
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
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'Ordered 10 min ago',
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
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Ordered 5 items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selectedTable == tableNumber
                                    ? CommonColors.primaryColor
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Table $tableNumber',
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
                }),
              ),
            ),
            if (selectedTable != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    pushToScreen(StaffHomeView(tableNo: selectedTable.toString()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Order',
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}