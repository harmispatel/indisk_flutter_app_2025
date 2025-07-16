import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api_service/models/order_history_master.dart';
import '../../../../utils/common_utills.dart';
import '../kitchen_staff_home/kitchen_staff_home_view_model.dart';

class KitchenStaffHistoryView extends StatefulWidget {
  const KitchenStaffHistoryView({super.key});

  @override
  State<KitchenStaffHistoryView> createState() =>
      _KitchenStaffHistoryViewState();
}

class _KitchenStaffHistoryViewState extends State<KitchenStaffHistoryView> {
  late KitchenStaffHomeViewModel mViewModel;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      mViewModel.getKitchenStaffHistory();
    });
  }

  void _showOrderDetails(BuildContext context, Orders order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OrderDetailsSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<KitchenStaffHomeViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
        elevation: 0,
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
          final itemHeight = 306.0;
          final aspectRatio = itemWidth / itemHeight;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: aspectRatio,
            // Adjusted aspect ratio
            children: List.generate(
              mViewModel.orderHistory.length,
              (index) {
                final order = mViewModel.orderHistory[index];
                final itemCount = order.items
                        ?.fold(0, (sum, item) => sum + (item.quantity ?? 0)) ??
                    0;
                return GestureDetector(
                  onTap: () => _showOrderDetails(context, order),
                  child: Container(
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       if (order.status == "Preparing") {
                        //         showRedToastMessage(
                        //             "This order is preparing, we can't deliver");
                        //       } else if (order.status == "Delivered") {
                        //         showRedToastMessage(
                        //             "This order is already delivered");
                        //       } else if (order.status == "Prepared") {
                        //         mViewModel.updateFoodStatus(
                        //             orderId: order.sId ?? '--',
                        //             status: 'Delivered');
                        //       }
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //         backgroundColor: order.status != "Prepared"
                        //             ? Colors.grey.shade500
                        //             : Colors.green,
                        //         minimumSize: const Size(double.infinity, 40),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8),
                        //         )),
                        //     child: const Text(
                        //       'Delivered',
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10)
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

class OrderDetailsSheet extends StatelessWidget {
  final Orders order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(),
          _buildDetailRow('Order ID:', order.sId ?? '--'),
          _buildDetailRow('Table:',
              order.tableNo == 0 ? 'Take Away' : 'Table ${order.tableNo}'),
          _buildDetailRow('Status:', order.status ?? 'N/A',
              color: _getStatusColor(order.status)),
          _buildDetailRow('Order Date:', order.orderDateFromNow ?? '--'),
          _buildDetailRow(
              'Payment Status:', order.paymentStatus?.toUpperCase() ?? 'N/A',
              color:
                  order.paymentStatus == 'paid' ? Colors.green : Colors.orange),
          SizedBox(height: 16),
          Text(
            'Items (${order.items?.length ?? 0})',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: order.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = order.items![index];
                return _buildOrderItem(item);
              },
            ),
          ),
          Divider(),
          _buildDetailRow('Sub Total:', '₹${order.subTotal ?? 0}'),
          _buildDetailRow('VAT:', '₹${order.vat ?? 0}'),
          _buildDetailRow('Total Amount:', '₹${order.totalAmount ?? 0}',
              isBold: true),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Items item) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.foodItem?.image?.isNotEmpty ?? false)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.foodItem!.image!.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.fastfood,
                            size: 30,
                            color: Colors.grey[400]),
                      ),
                    ),
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.foodItem?.name ?? '--',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Quantity: ${item.quantity ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Price: ₹${item.foodItem?.basePrice ?? 0}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (item.specialInstruction?.isNotEmpty ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Note: ${item.specialInstruction}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '₹${(item.foodItem?.basePrice ?? 0) * (item.quantity ?? 1)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Show modifiers, topups, variants if available
            if (item.modifier?.isNotEmpty ?? false)
              _buildAdditionalItems('Modifiers:', item.modifier!),
            if (item.topup?.isNotEmpty ?? false)
              _buildAdditionalItems('Top-ups:', item.topup!),
            if (item.varient?.isNotEmpty ?? false)
              _buildAdditionalItems('Variants:', item.varient!),
            if (item.discount != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Discount: ${item.discount!.percentage}% (${item.discount!.description})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalItems(String label, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: items.map((item) {
              // Handle different types of items
              String name;
              int? price;

              if (item is Modifier) {
                name = item.modifierName ?? '';
                price = item.price;
              } else if (item is Topup) {
                name = item.topupName ?? '';
                price = item.price;
              } else if (item is Varient) {
                name = item.varientName ?? '';
                price = item.price;
              } else if (item is Map<String, dynamic>) {
                // Fallback for raw map data
                name = item['modifierName'] ??
                    item['topupName'] ??
                    item['varientName'] ??
                    '';
                price = item['price'];
              } else {
                name = '';
                price = 0;
              }

              return Chip(
                label: Text(
                  '$name${price != null && price > 0 ? ' (+₹$price)' : ''}',
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: label.contains('Modifier')
                    ? Colors.blue[50]
                    : label.contains('Top-up')
                        ? Colors.green[50]
                        : Colors.purple[50],
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
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
