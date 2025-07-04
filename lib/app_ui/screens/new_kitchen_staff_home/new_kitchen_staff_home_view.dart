import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/kitchen_staff/kitchen_staff_home/kitchen_staff_home_view_model.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:provider/provider.dart';

class NewKitchenStaffHomeView extends StatefulWidget {
  const NewKitchenStaffHomeView({super.key});

  @override
  State<NewKitchenStaffHomeView> createState() =>
      _NewKitchenStaffHomeViewState();
}

class _NewKitchenStaffHomeViewState extends State<NewKitchenStaffHomeView> {
  late KitchenStaffHomeViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getKitchenStaffOrderList();
    });
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
                            tableItems: items,
                            isSelected: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<int, List<Map<String, dynamic>>> _groupItemsByTable() {
    final Map<int, List<Map<String, dynamic>>> tableItems = {};

    for (var order in mViewModel.kitchenOrders) {
      if (order.items != null && order.tableNo != null) {
        final tableNo = order.tableNo!.toInt();

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
}

class TableCard extends StatelessWidget {
  final String tableNo;
  final int totalItems;
  final List<Map<String, dynamic>> tableItems;
  final bool? isSelected;

  const TableCard({
    super.key,
    required this.tableNo,
    required this.totalItems,
    required this.tableItems,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final mViewModel =
        Provider.of<KitchenStaffHomeViewModel>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: CommonColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table header with icon and number
            Row(
              children: [
                Icon(
                  Icons.table_restaurant,
                  size: 40,
                  color: isSelected == true
                      ? CommonColors.primaryColor
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  tableNo == "0" ? "Take Away" : 'Table $tableNo',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$totalItems Items',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Items list
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tableItems.length,
                  itemBuilder: (context, index) {
                    final item = tableItems[index];
                    return OrderItemCard(
                      image: item['image'],
                      name: item['name'],
                      quantity: item['quantity'],
                      description: item['description'],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final orderIds = tableItems
                            .map((item) => item['orderId'] as String)
                            .toSet()
                            .toList();
                        for (final orderId in orderIds) {
                          mViewModel
                              .updateFoodStatus(
                                  orderId: orderId, status: "Prepared")
                              .whenComplete(() {
                            mViewModel.getKitchenStaffOrderList();
                          });
                        }
                      },
                      child: const Text(
                        'Mark as Ready',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Food image
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood,
                                size: 24, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.fastfood, size: 24, color: Colors.grey),
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
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
