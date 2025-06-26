import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_utills.dart';
import 'order_history_view_model.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  late OrderHistoryViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getOrderHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<OrderHistoryViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 5,
          // Reduced to 2 columns for better space
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
          // Adjusted aspect ratio
          children: List.generate(
            mViewModel.orderHistory.length,
            (index) {
              final order = mViewModel.orderHistory[index];
              final itemCount = order.items
                      ?.fold(0, (sum, item) => sum + (item.quantity ?? 0)) ??
                  0;
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          order.orderDateFromNow ?? '--',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/img_table.png',
                        // Replace with your image
                        height: 80,
                        width: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                    if (itemCount > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Ordered $itemCount items',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      order.tableNo == 0
                          ? "Take Away"
                          : 'Table ${order.tableNo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${order.status ?? 'N/A'}',
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: ₹${order.totalAmount ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (order.status == "Preparing") {
                            showRedToastMessage(
                                "This order is preparing, we can't deliver");
                          } else if (order.status == "Delivered") {
                            showRedToastMessage(
                                "This order is already delivered");
                          } else if (order.status == "Prepared") {
                            mViewModel.updateFoodStatus(
                                orderId: order.sId ?? '--',
                                status: 'Delivered');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: order.status != "Prepared"
                                ? Colors.grey.shade500
                                : Colors.green,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: const Text(
                          'Delivered',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'preparing':
        return Colors.orange;
      case 'prepared':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
