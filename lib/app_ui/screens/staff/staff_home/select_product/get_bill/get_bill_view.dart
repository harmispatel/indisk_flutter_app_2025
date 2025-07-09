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
import 'package:indisk_app/app_ui/screens/staff/staff_dashboard/staff_dasboard_view.dart';
import 'package:indisk_app/app_ui/screens/staff/staff_home/select_product/get_bill/viva_payment_service.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_utills.dart';
import 'package:provider/provider.dart';
import '../../../../../../utils/local_images.dart';
import '../../../../printer_connect/printer_connect_view.dart';
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

  @override
  void dispose() {
    super.dispose();
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PrinterScreen()),
                // );
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

class CashPaymentSuccessScreen extends StatelessWidget {
  // final VoidCallback onTapPressed;
  final Future<void> Function() onTapPressed;
  const CashPaymentSuccessScreen({required this.onTapPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                'Cash payment has been received.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cash payment has been received.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: "Done",
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
              // PrimaryButton(
              //   text: "Done",
              //   onPressed: () async {
              //     await onTapPressed();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => StaffDashboardView()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
