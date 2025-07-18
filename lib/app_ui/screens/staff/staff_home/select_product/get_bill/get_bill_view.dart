// import 'package:flutter/material.dart';
// import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
// import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/get_bill/viva_payment_service.dart';
// import 'package:indisk_app/utils/app_dimens.dart';
// import 'package:indisk_app/utils/common_utills.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../utils/local_images.dart';
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
//     print('GetBillView initialized with orderId: ${widget.orderNo}');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       mViewModel = Provider.of<StaffSelectProductViewModel>(context, listen: false);
//       print('Fetching bill for order: ${widget.orderNo}');
//       mViewModel?.getTableBill(
//           orderNo: widget.orderNo ?? '',
//           orderType: widget.tableNo == '0' ? 'Take away order' : '',
//           tableNo: widget.tableNo ?? '');
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
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
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Pay ₹$amount',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Select Payment Method',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildPaymentOption(
//                   icon: Icons.credit_card,
//                   title: 'Cash On',
//                   subtitle: 'Pay cash',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CashPaymentSuccessScreen(
//                           onPressed: () {
//                             mViewModel?.getUpdatePaymentApi(
//                                 tableNo: widget.tableNo,
//                                 orderId: widget.orderNo ?? "",
//                                 status: "paid",
//                                 paymentType: "cash");
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const Divider(),
//                 _buildPaymentOption(
//                     icon: Icons.account_balance_wallet,
//                     title: 'VivaPay',
//                     subtitle: 'Pay with ViaPay wallet',
//                     onTap: () async {
//                       try {
//                         await mViewModel?.getVivaPaymentApi(
//                             tableNo: widget.tableNo,orderId:widget.orderNo ?? "",);
//                         if (mViewModel?.stripePaymentUrl != null &&
//                             mViewModel!.stripePaymentUrl.isNotEmpty) {
//                           final result = await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => StripePaymentScreen(
//                                 checkoutUrl: mViewModel!.stripePaymentUrl,
//                               ),
//                             ),
//                           );
//                         } else {
//                           print('Stripe Payment URL is empty.');
//                           showRedToastMessage("Payment URL is not available.");
//                         }
//                       } catch (e) {
//                         print('Stripe API error: $e');
//                         showRedToastMessage("Payment initialization failed.");
//                       }
//                     }),
//                 const Divider(),
//                 _buildPaymentOption(
//                   icon: Icons.qr_code,
//                   title: 'QR Code',
//                   subtitle: 'Scan QR code to pay',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => QRPaymentScreen(
//                           onPressed: () {
//                             mViewModel?.getUpdatePaymentApi(
//                                 tableNo: widget.tableNo,
//                                 orderId: widget.orderNo ?? "",
//                                 status: "paid",
//                                 paymentType: "online");
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//               ],
//             ),
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
//
// class QRPaymentScreen extends StatelessWidget {
//   final VoidCallback onPressed;
//   const QRPaymentScreen({required this.onPressed, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Image(
//                 image: AssetImage(
//                   LocalImages.img_qr_code,
//                 ), // replace with your image path
//                 width: 400,
//                 height: 400,
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 PrimaryButton(
//                   text: "OK",
//                   width: 200,
//                   onPressed: onPressed,
//                 ),
//                 SizedBox(width: 16),
//                 PrimaryButton(
//                   text: "Cancel",
//                   width: 200,
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CashPaymentSuccessScreen extends StatelessWidget {
//   final VoidCallback onPressed;
//   const CashPaymentSuccessScreen({required this.onPressed, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Blue Checkmark
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   shape: BoxShape.circle,
//                 ),
//                 padding: const EdgeInsets.all(30),
//                 child: const Icon(
//                   Icons.check_circle,
//                   color: Colors.blue,
//                   size: 100,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Cash payment has been received.',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Cash payment has been received.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               PrimaryButton(
//                 text: "Done",
//                 onPressed: onPressed,
//               ),
//               // Done Button
//               // SizedBox(
//               //   width: 400,
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       Navigator.pushAndRemoveUntil(
//               //         context,
//               //         MaterialPageRoute(
//               //           builder: (context) => SelectTableView(),
//               //         ),
//               //             (Route<dynamic> route) => false, // Remove all previous routes
//               //       );
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.blue,
//               //       padding: const EdgeInsets.symmetric(vertical: 16),
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(12),
//               //       ),
//               //     ),
//               //     child: const Text(
//               //       'Done',
//               //       style: TextStyle(fontSize: 18, color: Colors.white),
//               //     ),
//               //   ),
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/printer_connect/printer_connect_view.dart';
import 'package:indisk_app/app_ui/screens/bluetooth_printer/bluetooth_printer_view.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_dashboard/staff_dasboard_view.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/get_bill/viva_payment_service.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';
import '../../../../../../utils/local_images.dart';
import '../../../../wifi_printer/wifi_printer_view.dart';
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
  bool paymentScreenZero = true;
  bool paymentScreenOne = false;
  bool paymentScreenTwo = false;
  bool paymentScreenThree = false;
  bool waitTillPaymentDoneScreen = false;
  bool onlinePaymentCompleted = false;
  String sessionId = "";
  String bearerToken = "";
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    print('GetBillView initialized with orderId: ${widget.orderNo}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mViewModel =
          Provider.of<StaffSelectProductViewModel>(context, listen: false);
      print('Fetching bill for order: ${widget.orderNo}');
      mViewModel?.getTableBill(
          orderNo: widget.orderNo ?? '',
          orderType: widget.tableNo == '0' ? 'Take away order' : '',
          tableNo: widget.tableNo ?? '');
    });
  }

  double tipAmount = 0.0;
  @override
  void dispose() {
    super.dispose();
  }

  void _showTipDialog() {
    final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
    final TextEditingController tipController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Waiter Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Total: ₹$amount'),
            const SizedBox(height: 10),
            TextField(
              controller: tipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tip Amount',
                prefixText: '₹',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (tipController.text.isNotEmpty) {
                setState(() {
                  tipAmount = double.tryParse(tipController.text) ?? 0.0;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add Tip'),
          ),
        ],
      ),
    );
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: PrimaryButton(
              width: 150,
              text: "Waiter Tip",
              onPressed: () => _showTipDialog(),
            ),
          ),
        ],
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
    final totalWithTip = (summary.totalAmount ?? 0) + tipAmount;
    return Column(
      children: [
        const Divider(thickness: 1),
        _buildSummaryRow('Sub Total:', '₹${summary.subTotal ?? 0}'),
        _buildSummaryRow(
            'VAT (${summary.vatPercentage ?? 0}%):', '₹${summary.vat ?? 0}'),
        const Divider(thickness: 1),
        _buildSummaryRow(
          'Total Amount:',
          '₹${totalWithTip.toStringAsFixed(2)}',
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
                // showDialog(
                //   context: context,
                //   builder: (context) => WifiPrinterPage(
                //     tableNo: widget.tableNo,
                //     orderNo: widget.orderNo ?? '',
                //     viewModel: viewModel,
                //   ),
                // );
                showSelectPrinterDialog(
                  context: context,
                  tableNo: widget.tableNo,
                  orderNo: widget.orderNo ?? '',
                  viewModel: viewModel,
                );
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
        ],
      ),
    );
  }

  void showSelectPrinterDialog({
    required BuildContext context,
    required String tableNo,
    required String orderNo,
    required StaffSelectProductViewModel viewModel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Printer Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.wifi),
              label: const Text("WiFi Printer"),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => WifiPrinterPage(
                    tableNo: tableNo,
                    orderNo: orderNo,
                    viewModel: viewModel,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text("Bluetooth Printer 0"),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (_) => ConnectToPrinter1(
                          title: "Demo Connect Printer",
                        ));
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text("Bluetooth Printer 1"),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (_) => ConnectToPrinter(
                        // title: "Demo Connect Printer",
                        )
                    // builder: (_) => BluetoothPrinterPage(
                    //   tableNo: tableNo,
                    //   orderNo: orderNo,
                    //   viewModel: viewModel,
                    // ),
                    );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text("Bluetooth Printer 2"),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context, builder: (_) => ConnectToPrinterView());
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth),
              label: const Text("flutter_bluetooth"),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context, builder: (_) => BluetoothPrinterPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _showPaymentOptions() {
  //   final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
  //   var modeOfPayment = 0;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: const EdgeInsets.all(20),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Pay ₹$amount',
  //                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 'Select Payment Method',
  //                 style: TextStyle(fontSize: 16),
  //               ),
  //               const SizedBox(height: 20),
  //
  //               // Cash Payment
  //               _buildPaymentOption(
  //                 icon: Icons.credit_card,
  //                 title: 'Cash On',
  //                 subtitle: 'Pay cash',
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => CashPaymentSuccessScreen(
  //                         totalAmount: amount.toString(),
  //                         onTapPressed: () async {
  //                           await mViewModel?.getUpdatePaymentApi(
  //                             tableNo: widget.tableNo,
  //                             orderId: mViewModel?.orderId ?? "",
  //                             status: "paid",
  //                             paymentType: "cash",
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //
  //               const Divider(),
  //
  //               // Viva Card Payment
  //               _buildPaymentOption(
  //                 icon: Icons.payments,
  //                 title: 'Viva Card Payment',
  //                 subtitle: 'Card',
  //                 onTap: () => _handleVivaCardPayment(amount, modeOfPayment),
  //               ),
  //
  //               const Divider(),
  //
  //               // Viva Wallet
  //               _buildPaymentOption(
  //                 icon: Icons.account_balance_wallet,
  //                 title: 'VivaPay',
  //                 subtitle: 'Pay with VivaPay wallet',
  //                 onTap: () async {
  //                   try {
  //                     await mViewModel?.getVivaPaymentApi(
  //                       tableNo: widget.tableNo,
  //                       orderId: mViewModel?.orderId ?? "",
  //                     );
  //                     if (mViewModel?.stripePaymentUrl?.isNotEmpty ?? false) {
  //                       await Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => StripePaymentScreen(
  //                             checkoutUrl: mViewModel!.stripePaymentUrl,
  //                           ),
  //                         ),
  //                       );
  //                     } else {
  //                       showRedToastMessage("Payment URL is not available.");
  //                     }
  //                   } catch (e) {
  //                     print('Stripe API error: $e');
  //                     showRedToastMessage("Payment initialization failed.");
  //                   }
  //                 },
  //               ),
  //
  //               const Divider(),
  //
  //               // QR Code Payment
  //               _buildPaymentOption(
  //                 icon: Icons.qr_code,
  //                 title: 'QR Code',
  //                 subtitle: 'Scan QR code to pay',
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => QRPaymentScreen(
  //                         onTapPressed: () async {
  //                           await mViewModel?.getUpdatePaymentApi(
  //                             tableNo: widget.tableNo,
  //                             orderId: mViewModel?.orderId ?? "",
  //                             status: "paid",
  //                             paymentType: "online",
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //
  //               const SizedBox(height: 20),
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('Cancel'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  //
  // Future<void> _handleVivaCardPayment(double amount, int modeOfPayment) async {
  //   try {
  //     setState(() {
  //       paymentScreenOne = false;
  //       paymentScreenTwo = false;
  //       paymentScreenThree = true;
  //       waitTillPaymentDoneScreen = false;
  //     });
  //     final clientId = 'u9a9gb29r757s77o913q0h0m5qa3sbvhu63egkk26qnj6.apps.vivapayments.com';
  //     final clientSecret = '2ByuC8oMS0aD5206r0253Uce2V86sE';
  //     // Step 1: Get access token
  //     final authHeader = base64Encode(utf8.encode('$clientId:$clientSecret'));
  //
  //     final tokenResponse = await http.post(
  //       Uri.parse('https://accounts.vivapayments.com/connect/token'),
  //       headers: {
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //         'Authorization': 'Basic $authHeader',
  //       },
  //       body: {'grant_type': 'client_credentials'},
  //     );
  //
  //     if (tokenResponse.statusCode != 200) {
  //       print(tokenResponse.statusCode);
  //       print(tokenResponse.statusCode);
  //       print(tokenResponse.statusCode);
  //       print(tokenResponse.statusCode);
  //       throw Exception('Failed to get token: ${tokenResponse.body}');
  //     }
  //
  //     final tokenData = jsonDecode(tokenResponse.body);
  //     final accessToken = tokenData['access_token'];
  //
  //     final sessionId = const Uuid().v1();
  //     setState(() {
  //       bearerToken = accessToken;
  //       this.sessionId = sessionId;
  //     });
  //
  //     // Step 2: Create transaction
  //     final transactionUrl = Uri.parse('https://api.vivapayments.com/ecr/v1/transactions:sale');
  //
  //     final transactionResponse = await http.post(
  //       transactionUrl,
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         "sessionId": "",
  //         "terminalId": "16281539",
  //         "cashRegisterId": "16281539",
  //         "amount": amount * 100,
  //         "currencyCode": "208",
  //         "merchantReference": "sales",
  //         "preauth": false,
  //         "maxInstalments": 0,
  //         "tipAmount": 0,
  //       }),
  //     );
  //
  //     if (transactionResponse.statusCode == 200) {
  //       print("Viva Card Payment successful");
  //
  //       await _printAndConfirmReceipt(amount, modeOfPayment);
  //     } else {
  //       print("Transaction failed: ${transactionResponse.body}");
  //       throw Exception("Transaction failed");
  //     }
  //   } catch (e) {
  //     print("Error in Viva card payment: $e");
  //     setState(() {
  //       paymentScreenTwo = true;
  //       waitTillPaymentDoneScreen = false;
  //     });
  //   }
  // }
  //
  // Future<void> _printAndConfirmReceipt(double amount, int modeOfPayment) async {
  //   try {
  //     setState(() {
  //       paymentScreenTwo = false;
  //       waitTillPaymentDoneScreen = true;
  //     });
  //
  //     // // Print receipt
  //     // await mViewModel?.printReceipt(
  //     //   tableNo: widget.tableNo,
  //     //   orderNo: widget.orderNo ?? '',
  //     //   amount: amount.toString(),
  //     //   modeOfPayment: modeOfPayment,
  //     // );
  //
  //     // Update payment status
  //     await mViewModel?.getUpdatePaymentApi(
  //       tableNo: widget.tableNo,
  //       orderId: mViewModel?.orderId ?? "",
  //       status: "paid",
  //       paymentType: "online",
  //     );
  //
  //     setState(() {
  //       onlinePaymentCompleted = true;
  //     });
  //
  //     // Navigate to success screen
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => StaffDashboardView()),
  //           (route) => false,
  //     );
  //   } catch (e) {
  //     print("Error in printing or confirming receipt: $e");
  //     showRedToastMessage("Failed to print or confirm payment.");
  //   }
  // }

  void _showPaymentOptions() {
    final amount = (mViewModel?.summary?.totalAmount ?? 0).toDouble();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
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
                  title: 'Cash On',
                  subtitle: 'Pay cash',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashPaymentSuccessScreen(
                          totalAmount: amount.toString(),
                          onTapPressed: () async {
                            await mViewModel?.getUpdatePaymentApi(
                                tableNo: widget.tableNo,
                                orderId: mViewModel?.orderId ?? "",
                                status: "paid",
                                paymentType: "cash");
                          },
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildPaymentOption(
                    icon: Icons.payments,
                    title: 'Viva Terminal',
                    subtitle: 'Card',
                    onTap: () async {
                      try {
                        await mViewModel?.getVivaTerminalPaymentApi(
                          tableNo: widget.tableNo,
                          orderId: mViewModel?.orderId ?? "",
                          terminalId: "16411813",
                        );
                        if (mViewModel?.vivaTerminalPaymentUrl != null &&
                            mViewModel!.vivaTerminalPaymentUrl.isNotEmpty) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StripePaymentScreen(
                                checkoutUrl: mViewModel!.vivaTerminalPaymentUrl,
                              ),
                            ),
                          );
                        } else {
                          print('Stripe Payment URL is empty.');
                          showRedToastMessage("Payment URL is not available.");
                        }
                      } catch (e) {
                        print('Stripe API error: $e');
                        showRedToastMessage("Payment initialization failed.");
                      }
                    }
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => VivaPaymentScreen(amount: amount),
                    //     ),
                    //   );
                    // },
                    ),
                const Divider(),
                _buildPaymentOption(
                    icon: Icons.account_balance_wallet,
                    title: 'VivaPay',
                    subtitle: 'Pay with ViaPay wallet',
                    onTap: () async {
                      try {
                        await mViewModel?.getVivaPaymentApi(
                          tableNo: widget.tableNo,
                          orderId: mViewModel?.orderId ?? "",
                        );
                        if (mViewModel?.stripePaymentUrl != null &&
                            mViewModel!.stripePaymentUrl.isNotEmpty) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StripePaymentScreen(
                                checkoutUrl: mViewModel!.stripePaymentUrl,
                              ),
                            ),
                          );
                        } else {
                          print('Stripe Payment URL is empty.');
                          showRedToastMessage("Payment URL is not available.");
                        }
                      } catch (e) {
                        print('Stripe API error: $e');
                        showRedToastMessage("Payment initialization failed.");
                      }
                    }),
                const Divider(),
                _buildPaymentOption(
                  icon: Icons.qr_code,
                  title: 'QR Code',
                  subtitle: 'Scan QR code to pay',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRPaymentScreen(
                          onTapPressed: () async {
                            await mViewModel?.getUpdatePaymentApi(
                                tableNo: widget.tableNo,
                                orderId: mViewModel?.orderId ?? "",
                                status: "paid",
                                paymentType: "online");
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
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

class QRPaymentScreen extends StatelessWidget {
  final Future<void> Function() onTapPressed;
  const QRPaymentScreen({required this.onTapPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage(
                  LocalImages.img_qr_code,
                ), // replace with your image path
                width: 400,
                height: 400,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  text: "OK",
                  width: 200,
                  onPressed: () async {
                    await onTapPressed();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StaffDashboardView()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
                SizedBox(width: 16),
                PrimaryButton(
                  text: "Cancel",
                  width: 200,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CashPaymentSuccessScreen extends StatefulWidget {
  final String totalAmount;
  final Future<void> Function() onTapPressed;

  const CashPaymentSuccessScreen({
    super.key,
    required this.onTapPressed,
    required this.totalAmount,
  });

  @override
  State<CashPaymentSuccessScreen> createState() =>
      _CashPaymentSuccessScreenState();
}

class _CashPaymentSuccessScreenState extends State<CashPaymentSuccessScreen> {
  final TextEditingController _givenAmountController = TextEditingController();
  double _balance = 0.0;
  String _message = "";

  void _calculateBalance() {
    final total = double.tryParse(widget.totalAmount) ?? 0;
    final given = double.tryParse(_givenAmountController.text) ?? 0;
    setState(() {
      _balance = given - total;
      if (_balance > 0) {
        _message = "Return change to customer: ₹${_balance.toStringAsFixed(2)}";
      } else if (_balance < 0) {
        _message = "Amount still due: ₹${(-_balance).toStringAsFixed(2)}";
      } else {
        _message = "Exact amount received.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(widget.totalAmount) ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Blue Checkmark
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(30),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Cash payment received',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Amount: ₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Input for Given Amount
                TextField(
                  controller: _givenAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Given Amount',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _calculateBalance(),
                ),

                const SizedBox(height: 20),

                // Balance Message
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _balance < 0 ? Colors.red : Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 40),
                PrimaryButton(
                  text: "Done",
                  onPressed: () async {
                    await widget.onTapPressed();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaffDashboardView(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CashPaymentSuccessScreen extends StatelessWidget {
//   final String totalAmount;
//   final Future<void> Function() onTapPressed;
//   const CashPaymentSuccessScreen(
//       {required this.onTapPressed, required this.totalAmount, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Blue Checkmark
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   shape: BoxShape.circle,
//                 ),
//                 padding: const EdgeInsets.all(30),
//                 child: const Icon(
//                   Icons.check_circle,
//                   color: Colors.blue,
//                   size: 100,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Cash payment has been received.',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Cash payment has been received.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               PrimaryButton(
//                 text: "Done",
//                 onPressed: () async {
//                   await onTapPressed();
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => StaffDashboardView()),
//                     (Route<dynamic> route) => false,
//                   );
//                 },
//               ),
//               // PrimaryButton(
//               //   text: "Done",
//               //   onPressed: () async {
//               //     await onTapPressed();
//               //     Navigator.push(
//               //         context,
//               //         MaterialPageRoute(
//               //             builder: (context) => StaffDashboardView()));
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
