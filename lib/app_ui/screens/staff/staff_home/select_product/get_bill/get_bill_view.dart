// import 'package:flutter/material.dart';
// import 'package:indisk_app/utils/app_dimens.dart';
// import 'package:provider/provider.dart';
// import '../staff_select_product_view_model.dart';
//
// class GetBillView extends StatefulWidget {
//   final String tableNo;
//   final String? orderNo;
//
//   const GetBillView({super.key, required this.tableNo, this.orderNo});
//
//   @override
//   State<GetBillView> createState() => _GetBillViewState();
// }
//
// class _GetBillViewState extends State<GetBillView> {
//   StaffSelectProductViewModel? mViewModel;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       mViewModel =
//           Provider.of<StaffSelectProductViewModel>(context, listen: false);
//       mViewModel?.getTableBill(
//           orderNo: widget.orderNo ?? '',
//           orderType: widget.tableNo == '0' ? 'takeaway' : '',
//           tableNo: widget.tableNo ?? '');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel =
//         mViewModel ?? Provider.of<StaffSelectProductViewModel>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Summary'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       bottomNavigationBar: _buildActionButtons(viewModel),
//       body: Center(
//         child: SizedBox(
//           width: kDeviceWidth / 2.8,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       // Restaurant Header
//                       _buildRestaurantHeader(),
//                       const SizedBox(height: 20),
//
//                       // Order Info
//                       _buildOrderInfo(viewModel),
//                       const SizedBox(height: 20),
//
//                       // Items List
//                       _buildItemsList(viewModel),
//                       const SizedBox(height: 20),
//
//                       // Summary Section
//                       _buildSummarySection(viewModel),
//                       const SizedBox(height: 20),
//
//                       // Thank You Message
//                       _buildThankYouMessage(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRestaurantHeader() {
//     return const Column(
//       children: [
//         Text(
//           'TASTY RESTAURANT',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: 4),
//         Text(
//           '123 Main Street, Food City',
//           style: TextStyle(fontSize: 14),
//         ),
//         Text(
//           'Phone: +1 234 567 8900',
//           style: TextStyle(fontSize: 14),
//         ),
//         Divider(thickness: 2),
//       ],
//     );
//   }
//
//   Widget _buildOrderInfo(StaffSelectProductViewModel viewModel) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Order No:',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(widget.orderNo ?? '--',
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Table No:',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(
//                 widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}',
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
//             Text(DateTime.now().toString().substring(0, 16)),
//           ],
//         ),
//         const Divider(thickness: 1),
//       ],
//     );
//   }
//
//   Widget _buildItemsList(StaffSelectProductViewModel viewModel) {
//     if (viewModel.orderedItems.isEmpty) {
//       return const Center(child: Text('No items in this order'));
//     }
//
//     return Column(
//       children: [
//         // Table Header
//         const Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child:
//                   Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             Expanded(
//               child: Text('Qty',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center),
//             ),
//             Expanded(
//               child: Text('Price',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.right),
//             ),
//           ],
//         ),
//         const Divider(),
//
//         // Items List
//         ...viewModel.orderedItems
//             .map((item) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(item.foodItem ?? '--',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             if (item.variantPrice != null &&
//                                 item.variantPrice! > 0)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text('Variant: +₹${item.variantPrice}',
//                                     style: const TextStyle(fontSize: 12)),
//                               ),
//                             if (item.modifierPrice != null &&
//                                 item.modifierPrice! > 0)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text('Modifier: +₹${item.modifierPrice}',
//                                     style: const TextStyle(fontSize: 12)),
//                               ),
//                             if (item.topupPrice != null && item.topupPrice! > 0)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text('Topup: +₹${item.topupPrice}',
//                                     style: const TextStyle(fontSize: 12)),
//                               ),
//                             if (item.discountPercent != null &&
//                                 item.discountPercent! > 0)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 2),
//                                 child: Text(
//                                     'Discount: ${item.discountPercent}%',
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.red)),
//                               ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Text('${item.quantity ?? 0}',
//                             textAlign: TextAlign.center),
//                       ),
//                       Expanded(
//                         child: Text('₹${item.totalPrice ?? 0}',
//                             textAlign: TextAlign.right),
//                       ),
//                     ],
//                   ),
//                 ))
//             .toList(),
//       ],
//     );
//   }
//
//   Widget _buildSummarySection(StaffSelectProductViewModel viewModel) {
//     if (viewModel.summary == null) {
//       return const SizedBox();
//     }
//
//     final summary = viewModel.summary!;
//
//     return Column(
//       children: [
//         const Divider(thickness: 1),
//         _buildSummaryRow('Sub Total:', '₹${summary.subTotal ?? 0}'),
//         _buildSummaryRow(
//             'VAT (${summary.vatPercentage ?? 0}%):', '₹${summary.vat ?? 0}'),
//         const Divider(thickness: 1),
//         _buildSummaryRow(
//           'Total Amount:',
//           '₹${summary.totalAmount ?? 0}',
//           isBold: true,
//           fontSize: 18,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSummaryRow(
//     String label,
//     String value, {
//     bool isBold = false,
//     double fontSize = 14,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildThankYouMessage() {
//     return const Column(
//       children: [
//         Divider(thickness: 2),
//         SizedBox(height: 10),
//         Text(
//           'Thank you for dining with us!',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           'Please visit again',
//           style: TextStyle(fontSize: 14),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButtons(StaffSelectProductViewModel viewModel) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(
//                 Icons.print,
//                 size: 20,
//                 color: Colors.black,
//               ),
//               label: const Text(
//                 'Print Bill',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onPressed: () {
//                 // Handle print bill action
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(
//                 Icons.payment,
//                 size: 20,
//                 color: Colors.white,
//               ),
//               label: const Text(
//                 'Take Payment',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 _showPaymentOptions();
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 backgroundColor: Colors.green,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: ElevatedButton.icon(
//               icon: const Icon(
//                 Icons.update,
//                 size: 20,
//                 color: Colors.white,
//               ),
//               label: const Text(
//                 'Update Status',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 // Handle update status action
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 backgroundColor: Colors.blue,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showPaymentOptions() {
//     final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Pay ₹$amount',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Select Payment Method',
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 20),
//               _buildPaymentOption(
//                 icon: Icons.credit_card,
//                 title: 'Razorpay',
//                 subtitle: 'Pay with credit/debit card or UPI',
//                 onTap: () {},
//               ),
//               const Divider(),
//               _buildPaymentOption(
//                 icon: Icons.account_balance_wallet,
//                 title: 'VivaPay',
//                 subtitle: 'Pay with ViaPay wallet',
//                 onTap: () {},
//               ),
//               const Divider(),
//               _buildPaymentOption(
//                 icon: Icons.qr_code,
//                 title: 'QR Code',
//                 subtitle: 'Scan QR code to pay',
//                 onTap: () {},
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Cancel'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPaymentOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(subtitle),
//       onTap: onTap,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/get_bill/viva_payment_service.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../staff_select_product_view_model.dart';

class GetBillView extends StatefulWidget {
  final String tableNo;
  final String? orderNo;

  const GetBillView({super.key, required this.tableNo, this.orderNo});

  @override
  State<GetBillView> createState() => _GetBillViewState();
}

class _GetBillViewState extends State<GetBillView> {
  StaffSelectProductViewModel? mViewModel;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel =
          Provider.of<StaffSelectProductViewModel>(context, listen: false);
      mViewModel?.getTableBill(
          orderNo: widget.orderNo ?? '',
          orderType: widget.tableNo == '0' ? 'takeaway' : '',
          tableNo: widget.tableNo ?? '');
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
  final vivaService = VivaPaymentService(
    clientId: 'demo',
    clientSecret: 'demo',
    isLive: false, // Change to true in production
  );

  Future<void> startPayment() async {
    final token = await vivaService.getAccessToken();
    if (token == null) return;

    final checkoutUrl = await vivaService.createPaymentOrder(
      token,
      1000, // Amount in cents (e.g. 1000 = €10.00)
      'customer@example.com',
    );

    if (checkoutUrl != null && await canLaunchUrl(Uri.parse(checkoutUrl))) {
      await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
    } else {
      print("Can't launch payment URL");
    }
  }
  @override
  Widget build(BuildContext context) {
    final viewModel =
        mViewModel ?? Provider.of<StaffSelectProductViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: _buildActionButtons(viewModel),
      body: Center(
        child: SizedBox(
          width: kDeviceWidth / 2.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Restaurant Header
                      _buildRestaurantHeader(),
                      const SizedBox(height: 20),

                      // Order Info
                      _buildOrderInfo(viewModel),
                      const SizedBox(height: 20),

                      // Items List
                      _buildItemsList(viewModel),
                      const SizedBox(height: 20),

                      // Summary Section
                      _buildSummarySection(viewModel),
                      const SizedBox(height: 20),

                      // Thank You Message
                      _buildThankYouMessage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return const Column(
      children: [
        Text(
          'TASTY RESTAURANT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '123 Main Street, Food City',
          style: TextStyle(fontSize: 14),
        ),
        Text(
          'Phone: +1 234 567 8900',
          style: TextStyle(fontSize: 14),
        ),
        Divider(thickness: 2),
      ],
    );
  }

  Widget _buildOrderInfo(StaffSelectProductViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Order No:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.orderNo ?? '--',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Table No:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(DateTime.now().toString().substring(0, 16)),
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget _buildItemsList(StaffSelectProductViewModel viewModel) {
    if (viewModel.orderedItems.isEmpty) {
      return const Center(child: Text('No items in this order'));
    }

    return Column(
      children: [
        // Table Header
        const Row(
          children: [
            Expanded(
              flex: 3,
              child:
                  Text('Item', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Text('Qty',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Price',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
        const Divider(),

        // Items List
        ...viewModel.orderedItems
            .map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.foodItem ?? '--',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            if (item.variantPrice != null &&
                                item.variantPrice! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text('Variant: +₹${item.variantPrice}',
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            if (item.modifierPrice != null &&
                                item.modifierPrice! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text('Modifier: +₹${item.modifierPrice}',
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            if (item.topupPrice != null && item.topupPrice! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text('Topup: +₹${item.topupPrice}',
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            if (item.discountPercent != null &&
                                item.discountPercent! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                    'Discount: ${item.discountPercent}%',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.red)),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text('${item.quantity ?? 0}',
                            textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: Text('₹${item.totalPrice ?? 0}',
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildSummarySection(StaffSelectProductViewModel viewModel) {
    if (viewModel.summary == null) {
      return const SizedBox();
    }

    final summary = viewModel.summary!;

    return Column(
      children: [
        const Divider(thickness: 1),
        _buildSummaryRow('Sub Total:', '₹${summary.subTotal ?? 0}'),
        _buildSummaryRow(
            'VAT (${summary.vatPercentage ?? 0}%):', '₹${summary.vat ?? 0}'),
        const Divider(thickness: 1),
        _buildSummaryRow(
          'Total Amount:',
          '₹${summary.totalAmount ?? 0}',
          isBold: true,
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouMessage() {
    return const Column(
      children: [
        Divider(thickness: 2),
        SizedBox(height: 10),
        Text(
          'Thank you for dining with us!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Please visit again',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(StaffSelectProductViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.print,
                size: 20,
                color: Colors.black,
              ),
              label: const Text(
                'Print Bill',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                // Handle print bill action
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.payment,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Take Payment',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _showPaymentOptions();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.green,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.update,
                size: 20,
                color: Colors.white,
              ),
              label: const Text(
                'Update Status',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Handle update status action
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: Text('Error: ${response.message ?? 'Unknown error'}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment ID: ${response.paymentId}'),
            Text('Order ID: ${response.orderId}'),
            const SizedBox(height: 10),
            const Text('Thank you for your payment!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (mViewModel != null) {
                mViewModel?.getTableBill(
                    orderNo: widget.orderNo ?? '',
                    orderType: widget.tableNo == '0' ? 'takeaway' : '',
                    tableNo: widget.tableNo ?? '');
                // mViewModel!.updateOrderPaymentStatus(
                //   orderNo: widget.orderNo ?? '',
                //   paymentId: response.paymentId ?? '',
                //   isPaid: true,
                // );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('External Wallet Selected'),
        content: Text('Wallet: ${response.walletName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openRazorpayPayment() {
    final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
    // if (amount <= 0) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Invalid amount for payment')),
    //   );
    //   return;
    // }
    var options = {
      'key': 'rzp_test_WGQ1BB4uyGl6uD', // Replace with your Razorpay key
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'Tasty Restaurant',
      'description': 'Payment for Order ${widget.orderNo}',
      'prefill': {
        'contact': '', // Add customer contact if available
        'email': '', // Add customer email if available
      },
      'theme': {
        'color': '#8130ac', // Customize color as per your app theme
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showPaymentOptions() {
    final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pay ₹$amount',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildPaymentOption(
                icon: Icons.credit_card,
                title: 'Razorpay',
                subtitle: 'Pay with credit/debit card or UPI',
                onTap: () {
                  _openRazorpayPayment();
                },
              ),
              const Divider(),
              _buildPaymentOption(
                icon: Icons.account_balance_wallet,
                title: 'VivaPay',
                subtitle: 'Pay with ViaPay wallet',
                onTap: startPayment,
              ),
              const Divider(),
              _buildPaymentOption(
                icon: Icons.qr_code,
                title: 'QR Code',
                subtitle: 'Scan QR code to pay',
                onTap: () {},
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
