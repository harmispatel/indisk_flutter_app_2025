import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_colors.dart';
import 'kitchen_staff_home_view_model.dart';

class KitchenStaffHomeView extends StatefulWidget {
  const KitchenStaffHomeView({super.key});

  @override
  State<KitchenStaffHomeView> createState() => _KitchenStaffHomeViewState();
}

class _KitchenStaffHomeViewState extends State<KitchenStaffHomeView> {
  late KitchenStaffHomeViewModel mViewModel;
  int? _selectedTable;
  List<Map<String, dynamic>> _selectedTableItems = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getKitchenStaffOrderList();
    });
  }

  Map<int, List<Map<String, dynamic>>> _groupItemsByTable() {
    final Map<int, List<Map<String, dynamic>>> tableItems = {};

    for (var order in mViewModel.kitchenOrders) {
      if (order.items != null && order.tableNo != null) {
        final tableNo = order.tableNo!;

        if (!tableItems.containsKey(tableNo)) {
          tableItems[tableNo] = [];
        }

        for (var item in order.items!) {
          if (item.foodItem != null) {
            tableItems[tableNo]!.add({
              'id': item.sId,
              'name': item.foodItem!.name,
              'quantity': item.quantity?.toString() ?? '0',
              'description': item.foodItem!.description,
              'image': item.foodItem!.image?.isNotEmpty == true
                  ? item.foodItem!.image!.first
                  : '',
              'tableNo': order.tableNo?.toString() ?? '',
              'orderId': order.sId,
            });
          }
        }
      }
    }
    return tableItems;
  }

  @override
  Widget build(BuildContext context) {

    mViewModel = Provider.of<KitchenStaffHomeViewModel>(context);
    final tableItems = _groupItemsByTable();
    final tableNumbers = tableItems.keys.toList()..sort();

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Tables List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Today's Orders",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: tableNumbers.length,
                        itemBuilder: (context, index) {
                          final tableNo = tableNumbers[index];
                          final items = tableItems[tableNo]!;

                          return TableCard(
                            tableNo: tableNo.toString(),
                            totalItems: items.length,
                            isSelected: _selectedTable == tableNo,
                            onTap: () {
                              setState(() {
                                _selectedTable = tableNo;
                                _selectedTableItems = items;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side - Table Order Details
          Container(
            color: Colors.grey[100],
            width: MediaQuery.of(context).size.width / 3.5,
            child: _selectedTable == null
                ? const Center(
                    child: Text(
                      "Select a table to view orders",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Table $_selectedTable',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Items: ${_selectedTableItems.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedTable = null;
                                  _selectedTableItems = [];
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedTableItems.length,
                          itemBuilder: (context, index) {
                            final item = _selectedTableItems[index];
                            return OrderItemCard(
                              image: item['image'],
                              name: item['name'],
                              quantity: item['quantity'],
                              description: item['description'],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: PrimaryButton(
                          text: "Order marked as ready",
                          onPressed: () {
                            final orderIds = _selectedTableItems
                                .map((item) => item['orderId'] as String)
                                .toSet()
                                .toList();

                            // Update status for all orders (you might want to handle this differently)
                            for (final orderId in orderIds) {
                              mViewModel.updateFoodStatus(
                                  orderId: orderId,
                                  status: "Prepared"
                              ).whenComplete(() {
                                setState(() {
                                  _selectedTable = null;
                                  _selectedTableItems = [];
                                });
                                mViewModel.getKitchenStaffOrderList();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final String tableNo;
  final int totalItems;
  final bool isSelected;
  final GestureTapCallback onTap;

  const TableCard({
    super.key,
    required this.tableNo,
    required this.totalItems,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? CommonColors.primaryColor.withOpacity(0.2)
              : Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Table icon with number
              Icon(
                Icons.table_restaurant,
                size: 50,
                color: isSelected ? CommonColors.primaryColor : Colors.grey,
              ),
              const SizedBox(height: 8),

              // Table number
              Text(
                tableNo == "0"
                    ? "Take Away"
                    : 'Table $tableNo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? CommonColors.primaryColor : Colors.black,
                ),
              ),
              const SizedBox(height: 4),

              // Total items count
              Text(
                'Items: $totalItems',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  final String image;
  final String name;
  final String quantity;
  final String description;

  const OrderItemCard({
    super.key,
    required this.image,
    required this.name,
    required this.quantity,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food image
            Container(
              height: 60,
              width: 60,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.fastfood,
                          size: 30,
                          color: Colors.grey),
                    )
                  : const Icon(Icons.fastfood, size: 30, color: Colors.grey),
            ),
            const SizedBox(width: 12),

            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
