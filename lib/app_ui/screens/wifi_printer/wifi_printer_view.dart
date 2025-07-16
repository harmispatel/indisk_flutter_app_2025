// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:multicast_dns/multicast_dns.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // Removed: import 'package:esc_pos_printer_manager/esc_pos_printer_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../staff/staff_home/select_product/staff_select_product_view_model.dart';
//
// class WifiPrinterPage extends StatefulWidget {
//   final String tableNo;
//   final String orderNo;
//   final StaffSelectProductViewModel viewModel;
//
//   const WifiPrinterPage({
//     super.key,
//     required this.tableNo,
//     required this.orderNo,
//     required this.viewModel,
//   });
//
//   @override
//   State<WifiPrinterPage> createState() => _WifiPrinterPageState();
// }
//
// class _WifiPrinterPageState extends State<WifiPrinterPage> {
//   List<MDnsDiscoveredPrinter> _wifiPrinters = [];
//   MDnsDiscoveredPrinter? _selectedPrinter;
//   bool _isScanning = false;
//   bool _isPrinting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedPrinter();
//   }
//
//   Future<void> _loadSavedPrinter() async {
//     final prefs = await SharedPreferences.getInstance();
//     final ip = prefs.getString('printer_ip');
//     final port = prefs.getInt('printer_port');
//     final name = prefs.getString('printer_name');
//     if (ip != null && port != null && name != null) {
//       setState(() {
//         _selectedPrinter = MDnsDiscoveredPrinter(
//           name: name,
//           host: ip,
//           port: port,
//           ip: ip,
//         );
//       });
//     }
//   }
//
//   Future<void> _scanWifiPrinters() async {
//     setState(() {
//       _isScanning = true;
//       _wifiPrinters.clear();
//     });
//
//     final MDnsClient client = MDnsClient();
//     await client.start();
//
//     final List<MDnsDiscoveredPrinter> found = [];
//
//     await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
//         ResourceRecordQuery.serverPointer('_printer._tcp.local'))) {
//       await for (final SrvResourceRecord srv
//           in client.lookup<SrvResourceRecord>(
//               ResourceRecordQuery.service(ptr.domainName))) {
//         await for (final IPAddressResourceRecord ip
//             in client.lookup<IPAddressResourceRecord>(
//                 ResourceRecordQuery.addressIPv4(srv.target))) {
//           found.add(MDnsDiscoveredPrinter(
//             name: ptr.domainName,
//             host: srv.target,
//             port: srv.port,
//             ip: ip.address.address,
//           ));
//         }
//       }
//     }
//
//     client.stop();
//     setState(() {
//       _wifiPrinters = found;
//       _isScanning = false;
//     });
//   }
//
//   void _showPrintDialog() {
//     if (_selectedPrinter == null) return;
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Print'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Printer: ${_selectedPrinter!.name}'),
//             Text('IP: ${_selectedPrinter!.ip}'),
//             Text('Port: 9100 (ESC/POS)'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _printToWifiPrinter();
//             },
//             child: const Text('Print Now'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _printToWifiPrinter() async {
//     if (_selectedPrinter == null) return;
//
//     setState(() => _isPrinting = true);
//
//     try {
//       final socket = await Socket.connect(
//         _selectedPrinter!.ip,
//         9100,
//         timeout: const Duration(seconds: 5),
//       );
//
//       final bytes = _buildReceiptBytes();
//       socket.add(bytes);
//       await socket.flush();
//       await socket.close();
//
//       // Save printer
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('printer_ip', _selectedPrinter!.ip);
//       await prefs.setInt('printer_port', _selectedPrinter!.port);
//       await prefs.setString('printer_name', _selectedPrinter!.name);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Print sent successfully'),
//             backgroundColor: Colors.green),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Failed to print: $e'), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() => _isPrinting = false);
//     }
//   }
//
//   List<int> _buildReceiptBytes() {
//     final vm = widget.viewModel;
//     final summary = vm.summary!;
//     List<int> bytes = [];
//
//     // ESC/POS: Init, center align, bold double height
//     bytes.addAll([0x1B, 0x40]); // Initialize
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\x1B\x21\x20'.codeUnits); // Bold, double height
//     bytes.addAll('TASTY RESTAURANT\n'.codeUnits);
//
//     // Normal text
//     bytes.addAll('\x1B\x21\x00'.codeUnits);
//     bytes.addAll('123 Main Street, Food City\n'.codeUnits);
//     bytes.addAll('Phone: +1 234 567 8900\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits); // Divider
//
//     // Left align for order info
//     bytes.addAll('\x1B\x61\x00'.codeUnits);
//     bytes.addAll('Order No: ${widget.orderNo ?? '--'}\n'.codeUnits);
//     bytes.addAll(
//         'Table No: ${widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}'}\n'
//             .codeUnits);
//     bytes.addAll(
//         'Date: ${DateTime.now().toString().substring(0, 16)}\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Table header
//     bytes.addAll('Item                          Qty   Price\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits);
//
//     for (var item in vm.orderedItems) {
//       final itemName = (item.foodItem ?? '').padRight(28).substring(0, 28);
//       final qty = (item.quantity ?? 0).toString().padLeft(3);
//       final price = '₹${item.totalPrice ?? 0}'.padLeft(7);
//       bytes.addAll('$itemName $qty $price\n'.codeUnits);
//     }
//
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Summary
//     bytes.addAll('Sub Total:'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.subTotal}\n'.codeUnits);
//
//     bytes.addAll('VAT (${summary.vatPercentage}%):'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.vat}\n'.codeUnits);
//
//     bytes.addAll('\x1B\x45\x01'.codeUnits); // Bold on
//     bytes.addAll('Total Amount:'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.totalAmount}\n'.codeUnits);
//     bytes.addAll('\x1B\x45\x00'.codeUnits); // Bold off
//
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Thank you
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\nThank you for dining with us!\n'.codeUnits);
//     bytes.addAll('Please visit again\n\n\n'.codeUnits);
//
//     // Cut
//     bytes.addAll([0x1D, 0x56, 0x41, 0x10]);
//
//     return bytes;
//   }
//
//   void _previewPrint() {
//     final vm = widget.viewModel;
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Print Preview'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Column(
//                     children: const [
//                       Text('TASTY RESTAURANT',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20)),
//                       Text('123 Main Street, Food City'),
//                       Text('Phone: +1 234 567 8900'),
//                     ],
//                   ),
//                 ),
//                 const Divider(thickness: 1),
//                 Text('Order No: ${widget.orderNo ?? "--"}'),
//                 Text(
//                     'Table No: ${widget.tableNo == '0' ? "Take Away" : "Table ${widget.tableNo}"}'),
//                 Text('Date: ${DateTime.now().toString().substring(0, 16)}'),
//                 const Divider(thickness: 1),
//                 const Text('Item                               Qty   Price',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const Divider(thickness: 1),
//                 ...vm.orderedItems.map((item) {
//                   final name = item.foodItem ?? '';
//                   final qty = item.quantity ?? 0;
//                   final price = item.totalPrice ?? 0;
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Row(
//                       children: [
//                         Expanded(flex: 3, child: Text(name)),
//                         Expanded(
//                             child: Text('$qty', textAlign: TextAlign.center)),
//                         Expanded(
//                             child: Text('₹$price', textAlign: TextAlign.right)),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//                 const Divider(thickness: 1),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Sub Total:'),
//                       Text('₹${vm.summary?.subTotal ?? 0}'),
//                     ]),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('VAT (${vm.summary?.vatPercentage ?? 0}%):'),
//                       Text('₹${vm.summary?.vat ?? 0}'),
//                     ]),
//                 const Divider(thickness: 1),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Text('Total Amount:',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Text('₹550',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ]),
//                 const Divider(thickness: 1),
//                 const Center(
//                     child: Text(
//                         'Thank you for dining with us!\nPlease visit again')),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.print),
//               label: const Text("Print Now"),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _printToWifiPrinter();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Select WiFi Printer"),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (_selectedPrinter != null)
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.print),
//                 label: Text("Use Last Printer: ${_selectedPrinter!.name}"),
//                 onPressed: _isPrinting ? null : _showPrintDialog,
//               ),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: _isPrinting ? null : _previewPrint,
//               icon: const Icon(Icons.print),
//               label: const Text("Preview & Print"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               onPressed: _isScanning ? null : _scanWifiPrinters,
//               icon: const Icon(Icons.wifi),
//               label: const Text("Scan WiFi Printers"),
//             ),
//             const SizedBox(height: 12),
//             if (_wifiPrinters.isEmpty)
//               const Text("No printers found.")
//             else
//               SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   itemCount: _wifiPrinters.length,
//                   itemBuilder: (_, index) {
//                     final printer = _wifiPrinters[index];
//                     return ListTile(
//                       title: Text(printer.name),
//                       subtitle:
//                           Text("IP: ${printer.ip}, Port: ${printer.port}"),
//                       trailing: ElevatedButton(
//                         onPressed: _isPrinting
//                             ? null
//                             : () {
//                                 setState(() => _selectedPrinter = printer);
//                                 _showPrintDialog();
//                               },
//                         child: const Text("Print"),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
//
// class MDnsDiscoveredPrinter {
//   final String name;
//   final String host;
//   final int port;
//   final String ip;
//
//   MDnsDiscoveredPrinter({
//     required this.name,
//     required this.host,
//     required this.port,
//     required this.ip,
//   });
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MDnsDiscoveredPrinter &&
//           runtimeType == other.runtimeType &&
//           ip == other.ip &&
//           port == other.port;
//
//   @override
//   int get hashCode => ip.hashCode ^ port.hashCode;
// }
//
// // --- BluetoothPrinterPage is commented out due to missing package and types ---
// /*
// class BluetoothPrinterPage extends StatefulWidget {
//   final String tableNo;
//   final String orderNo;
//   final StaffSelectProductViewModel viewModel;
//
//   const BluetoothPrinterPage({
//     super.key,
//     required this.tableNo,
//     required this.orderNo,
//     required this.viewModel,
//   });
//
//   @override
//   State<BluetoothPrinterPage> createState() => _BluetoothPrinterPageState();
// }
//
// class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
//   // final PrinterManager _printerManager = PrinterManager.instance;
//   // List<PrinterDevice> _bluetoothPrinters = [];
//   // PrinterDevice? _selectedPrinter;
//   // bool _isScanning = false;
//
//   // Future<void> _scanBluetoothPrinters() async {
//   //   if (!await Permission.bluetoothScan.request().isGranted) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text("Bluetooth permission denied")),
//   //     );
//   //     return;
//   //   }
//   //   setState(() {
//   //     _isScanning = true;
//   //     _bluetoothPrinters.clear();
//   //   });
//   //   _printerManager.discovery(type: PrinterType.bluetooth).listen((device) {
//   //     setState(() {
//   //       _bluetoothPrinters.add(device);
//   //     });
//   //   }, onDone: () {
//   //     setState(() {
//   //       _isScanning = false;
//   //     });
//   //   });
//   // }
//
//   // Future<void> _printToBluetoothPrinter() async {
//   //   if (_selectedPrinter == null) return;
//   //   try {
//   //     if (_selectedPrinter != null) {
//   //       await _printerManager.connect(
//   //         type: PrinterType.bluetooth,
//   //         model: BluetoothPrinterInput(
//   //           name: _selectedPrinter!.name,
//   //           address: _selectedPrinter!.address.toString(),
//   //         ),
//   //       );
//   //       final bytes = _buildReceiptBytes();
//   //       await _printerManager.send(type: PrinterType.bluetooth, bytes: bytes);
//   //       await _printerManager.disconnect(type: PrinterType.bluetooth);
//   //     }
//   //     final bytes = _buildReceiptBytes();
//   //     await _printerManager.send(type: PrinterType.bluetooth, bytes: bytes);
//   //     await _printerManager.disconnect(type: PrinterType.bluetooth);
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //           content: Text("Printed over Bluetooth"),
//   //           backgroundColor: Colors.green),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //           content: Text("Bluetooth print failed: $e"),
//   //           backgroundColor: Colors.red),
//   //     );
//   //   }
//   // }
//
//   // List<int> _buildReceiptBytes() {
//   //   final vm = widget.viewModel;
//   //   List<int> bytes = [];
//   //   bytes.addAll([0x1B, 0x40]); // Init
//   //   bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//   //   bytes.addAll('RESTAURANT\n'.codeUnits);
//   //   bytes.addAll('\x1B\x61\x00'.codeUnits); // Left align
//   //   bytes.addAll('Order:  {widget.orderNo}\n'.codeUnits);
//   //   bytes.addAll('Table:  {widget.tableNo}\n'.codeUnits);
//   //   bytes.addAll(('-' * 40).codeUnits);
//   //   for (var item in vm.orderedItems) {
//   //     bytes.addAll(
//   //         ' {item.foodItem} x {item.quantity}   {item.totalPrice}\n'.codeUnits);
//   //   }
//   //   bytes.addAll(('-' * 40).codeUnits);
//   //   bytes.addAll('\x1B\x61\x01'.codeUnits); // Center
//   //   bytes.addAll('Thank You!\n\n\n'.codeUnits);
//   //   bytes.addAll([0x1D, 0x56, 0x41, 0x10]); // Cut
//   //   return bytes;
//   // }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return AlertDialog(
//   //     title: const Text("Bluetooth Printer"),
//   //     content: Column(
//   //       mainAxisSize: MainAxisSize.min,
//   //       children: [
//   //         ElevatedButton(
//   //           onPressed: _isScanning ? null : _scanBluetoothPrinters,
//   //           child: const Text("Scan Bluetooth Printers"),
//   //         ),
//   //         const SizedBox(height: 10),
//   //         if (_bluetoothPrinters.isNotEmpty)
//   //           ..._bluetoothPrinters.map((printer) => ListTile(
//   //             title: Text(printer.address.toString()),
//   //             trailing: ElevatedButton(
//   //               onPressed: () {
//   //                 setState(() => _selectedPrinter = printer);
//   //                 _printToBluetoothPrinter();
//   //               },
//   //               child: const Text("Print"),
//   //             ),
//   //           )),
//   //       ],
//   //     ),
//   //   );
//   // }
// }
// */
// // --- End BluetoothPrinterPage ---




import 'dart:async';
import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart' as bt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Removed: import 'package:esc_pos_printer_manager/esc_pos_printer_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import '../staff/staff_home/select_product/staff_select_product_view_model.dart';

class WifiPrinterPage extends StatefulWidget {
  final String tableNo;
  final String orderNo;
  final StaffSelectProductViewModel viewModel;

  const WifiPrinterPage({
    super.key,
    required this.tableNo,
    required this.orderNo,
    required this.viewModel,
  });

  @override
  State<WifiPrinterPage> createState() => _WifiPrinterPageState();
}

class _WifiPrinterPageState extends State<WifiPrinterPage> {
  List<MDnsDiscoveredPrinter> _wifiPrinters = [];
  MDnsDiscoveredPrinter? _selectedPrinter;
  bool _isScanning = false;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPrinter();
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('printer_ip');
    final port = prefs.getInt('printer_port');
    final name = prefs.getString('printer_name');
    if (ip != null && port != null && name != null) {
      setState(() {
        _selectedPrinter = MDnsDiscoveredPrinter(
          name: name,
          host: ip,
          port: port,
          ip: ip,
        );
      });
    }
  }

  Future<void> _scanWifiPrinters() async {
    setState(() {
      _isScanning = true;
      _wifiPrinters.clear();
    });

    final MDnsClient client = MDnsClient();
    await client.start();

    final List<MDnsDiscoveredPrinter> found = [];

    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_printer._tcp.local'))) {
      await for (final SrvResourceRecord srv
      in client.lookup<SrvResourceRecord>(
          ResourceRecordQuery.service(ptr.domainName))) {
        await for (final IPAddressResourceRecord ip
        in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target))) {
          found.add(MDnsDiscoveredPrinter(
            name: ptr.domainName,
            host: srv.target,
            port: srv.port,
            ip: ip.address.address,
          ));
        }
      }
    }

    client.stop();
    setState(() {
      _wifiPrinters = found;
      _isScanning = false;
    });
  }

  void _showPrintDialog() {
    if (_selectedPrinter == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Print'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Printer: ${_selectedPrinter!.name}'),
            Text('IP: ${_selectedPrinter!.ip}'),
            Text('Port: 9100 (ESC/POS)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _printToWifiPrinter();
            },
            child: const Text('Print Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _printToWifiPrinter() async {
    if (_selectedPrinter == null) return;

    setState(() => _isPrinting = true);

    try {
      final socket = await Socket.connect(
        _selectedPrinter!.ip,
        9100,
        timeout: const Duration(seconds: 5),
      );

      final bytes = _buildReceiptBytes();
      socket.add(bytes);
      await socket.flush();
      await socket.close();

      // Save printer
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('printer_ip', _selectedPrinter!.ip);
      await prefs.setInt('printer_port', _selectedPrinter!.port);
      await prefs.setString('printer_name', _selectedPrinter!.name);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Print sent successfully'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to print: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  List<int> _buildReceiptBytes() {
    final vm = widget.viewModel;
    final summary = vm.summary!;
    List<int> bytes = [];

    // ESC/POS: Init, center align, bold double height
    bytes.addAll([0x1B, 0x40]); // Initialize
    bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
    bytes.addAll('\x1B\x21\x20'.codeUnits); // Bold, double height
    bytes.addAll('TASTY RESTAURANT\n'.codeUnits);

    // Normal text
    bytes.addAll('\x1B\x21\x00'.codeUnits);
    bytes.addAll('123 Main Street, Food City\n'.codeUnits);
    bytes.addAll('Phone: +1 234 567 8900\n'.codeUnits);
    bytes.addAll(('-' * 48).codeUnits); // Divider

    // Left align for order info
    bytes.addAll('\x1B\x61\x00'.codeUnits);
    bytes.addAll('Order No: ${widget.orderNo ?? '--'}\n'.codeUnits);
    bytes.addAll(
        'Table No: ${widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}'}\n'
            .codeUnits);
    bytes.addAll(
        'Date: ${DateTime.now().toString().substring(0, 16)}\n'.codeUnits);
    bytes.addAll(('-' * 48).codeUnits);

    // Table header
    bytes.addAll('Item                          Qty   Price\n'.codeUnits);
    bytes.addAll(('-' * 48).codeUnits);

    for (var item in vm.orderedItems) {
      final itemName = (item.foodItem ?? '').padRight(28).substring(0, 28);
      final qty = (item.quantity ?? 0).toString().padLeft(3);
      final price = '₹${item.totalPrice ?? 0}'.padLeft(7);
      bytes.addAll('$itemName $qty $price\n'.codeUnits);
    }

    bytes.addAll(('-' * 48).codeUnits);

    // Summary
    bytes.addAll('Sub Total:'.padRight(40).codeUnits);
    bytes.addAll('₹${summary.subTotal}\n'.codeUnits);

    bytes.addAll('VAT (${summary.vatPercentage}%):'.padRight(40).codeUnits);
    bytes.addAll('₹${summary.vat}\n'.codeUnits);

    bytes.addAll('\x1B\x45\x01'.codeUnits); // Bold on
    bytes.addAll('Total Amount:'.padRight(40).codeUnits);
    bytes.addAll('₹${summary.totalAmount}\n'.codeUnits);
    bytes.addAll('\x1B\x45\x00'.codeUnits); // Bold off

    bytes.addAll(('-' * 48).codeUnits);

    // Thank you
    bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
    bytes.addAll('\nThank you for dining with us!\n'.codeUnits);
    bytes.addAll('Please visit again\n\n\n'.codeUnits);

    // Cut
    bytes.addAll([0x1D, 0x56, 0x41, 0x10]);

    return bytes;
  }

  void _previewPrint() {
    final vm = widget.viewModel;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Print Preview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: const [
                      Text('TASTY RESTAURANT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text('123 Main Street, Food City'),
                      Text('Phone: +1 234 567 8900'),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                Text('Order No: ${widget.orderNo ?? "--"}'),
                Text(
                    'Table No: ${widget.tableNo == '0' ? "Take Away" : "Table ${widget.tableNo}"}'),
                Text('Date: ${DateTime.now().toString().substring(0, 16)}'),
                const Divider(thickness: 1),
                const Text('Item                               Qty   Price',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(thickness: 1),
                ...vm.orderedItems.map((item) {
                  final name = item.foodItem ?? '';
                  final qty = item.quantity ?? 0;
                  final price = item.totalPrice ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(name)),
                        Expanded(
                            child: Text('$qty', textAlign: TextAlign.center)),
                        Expanded(
                            child: Text('₹$price', textAlign: TextAlign.right)),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(thickness: 1),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sub Total:'),
                      Text('₹${vm.summary?.subTotal ?? 0}'),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('VAT (${vm.summary?.vatPercentage ?? 0}%):'),
                      Text('₹${vm.summary?.vat ?? 0}'),
                    ]),
                const Divider(thickness: 1),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Total Amount:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹550',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                const Divider(thickness: 1),
                const Center(
                    child: Text(
                        'Thank you for dining with us!\nPlease visit again')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text("Print Now"),
              onPressed: () {
                Navigator.pop(context);
                _printToWifiPrinter();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select WiFi Printer"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedPrinter != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: Text("Use Last Printer: ${_selectedPrinter!.name}"),
                onPressed: _isPrinting ? null : _showPrintDialog,
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isPrinting ? null : _previewPrint,
              icon: const Icon(Icons.print),
              label: const Text("Preview & Print"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanWifiPrinters,
              icon: const Icon(Icons.wifi),
              label: const Text("Scan WiFi Printers"),
            ),
            const SizedBox(height: 12),
            if (_wifiPrinters.isEmpty)
              const Text("No printers found.")
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: _wifiPrinters.length,
                  itemBuilder: (_, index) {
                    final printer = _wifiPrinters[index];
                    return ListTile(
                      title: Text(printer.name),
                      subtitle:
                      Text("IP: ${printer.ip}, Port: ${printer.port}"),
                      trailing: ElevatedButton(
                        onPressed: _isPrinting
                            ? null
                            : () {
                          setState(() => _selectedPrinter = printer);
                          _showPrintDialog();
                        },
                        child: const Text("Print"),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class MDnsDiscoveredPrinter {
  final String name;
  final String host;
  final int port;
  final String ip;

  MDnsDiscoveredPrinter({
    required this.name,
    required this.host,
    required this.port,
    required this.ip,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MDnsDiscoveredPrinter &&
              runtimeType == other.runtimeType &&
              ip == other.ip &&
              port == other.port;

  @override
  int get hashCode => ip.hashCode ^ port.hashCode;
}

// class BluetoothPrinterPage extends StatefulWidget {
//   final String tableNo;
//   final String orderNo;
//   final StaffSelectProductViewModel viewModel;
//
//   const BluetoothPrinterPage({
//     required this.tableNo,
//     required this.orderNo,
//     required this.viewModel,
//     super.key,
//   });
//
//   @override
//   State<BluetoothPrinterPage> createState() => _BluetoothPrinterPageState();
// }
//
// class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
//   List<BluetoothDevice> _bluetoothDevices = <BluetoothDevice>[];
//   BluetoothDevice? _selectedDevice;
//   bool _isLoading = false;
//   bool _isScanning = false;
//   int _loadingAtIndex = -1;
//   StreamSubscription<List<ScanResult>>? _scanSubscription;
//   StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
//
//   @override
//   void dispose() {
//     _scanSubscription?.cancel();
//     _connectionSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _checkPermissions() async {
//     if (Platform.isAndroid) {
//       final statuses = await [
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//         Permission.location,
//       ].request();
//
//       if (!statuses[Permission.bluetoothScan]!.isGranted ||
//           !statuses[Permission.bluetoothConnect]!.isGranted ||
//           !statuses[Permission.location]!.isGranted) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Bluetooth permissions are required'),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//         return;
//       }
//     }
//   }
//
//   Future<void> _onScanPressed() async {
//     if (_isScanning) return;
//
//     await _checkPermissions();
//
//     setState(() {
//       _isLoading = true;
//       _isScanning = true;
//       _bluetoothDevices.clear();
//     });
//
//     try {
//       // Cancel any existing scan
//       _scanSubscription?.cancel();
//       await FlutterBluePlus.stopScan();
//
//       // Start new scan
//       await FlutterBluePlus.startScan(
//         timeout: const Duration(seconds: 15),
//         androidUsesFineLocation: false,
//       );
//
//       _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
//         final uniqueDevices = <BluetoothDevice>[];
//         final deviceIds = <String>{};
//
//         for (var result in results) {
//           final device = result.device;
//
//           // FILTER only printer-like devices
//           final name = device.platformName.isNotEmpty
//               ? device.platformName
//               : device.advName.isNotEmpty
//               ? device.advName
//               : device.localName.isNotEmpty
//               ? device.localName
//               : '';
//
//           final lowerName = name.toLowerCase();
//
//           final looksLikePrinter = lowerName.contains('printer') ||
//               lowerName.contains('pos') ||
//               lowerName.contains('rp') ||
//               lowerName.contains('bixolon') ||
//               lowerName.contains('zebra') ||
//               lowerName.contains('star') ||
//               lowerName.contains('epson') ||
//               lowerName.contains('hprt') ||
//               lowerName.contains('citizen') ||
//               lowerName.contains('tsc') ||
//               lowerName.contains('gprinter') ||
//               lowerName.contains('gp');
//           if (!deviceIds.contains(device.remoteId.str) && looksLikePrinter) {
//             deviceIds.add(device.remoteId.str);
//             uniqueDevices.add(device);
//           }
//         }
//
//         if (mounted) {
//           setState(() {
//             _bluetoothDevices = uniqueDevices;
//             _isLoading = false;
//           });
//         }
//       });
//
//
//       // Auto stop after timeout
//       await Future.delayed(const Duration(seconds: 15));
//       await FlutterBluePlus.stopScan();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Scan error: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isScanning = false;
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _onSelectDevice(int index) async {
//     if (_isLoading || index >= _bluetoothDevices.length) return;
//
//     setState(() {
//       _isLoading = true;
//       _loadingAtIndex = index;
//     });
//
//     try {
//       final device = _bluetoothDevices[index];
//
//       // Disconnect from current device if different
//       if (_selectedDevice != null && _selectedDevice!.remoteId != device.remoteId) {
//         await _selectedDevice!.disconnect();
//       }
//
//       // Connect to new device
//       _connectionSubscription?.cancel();
//       _connectionSubscription = device.connectionState.listen((state) {
//         debugPrint('Connection state: $state');
//       });
//
//       await device.connect(
//         autoConnect: false,
//         timeout: const Duration(seconds: 15),
//       );
//
//       // Discover services
//       await device.discoverServices();
//
//       setState(() {
//         _selectedDevice = device;
//       });
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connected to ${_getDeviceName(device)}')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Connection failed: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _loadingAtIndex = -1;
//         });
//       }
//     }
//   }
//
//   Future<void> _onDisconnectDevice() async {
//     if (_selectedDevice == null) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       await _selectedDevice!.disconnect();
//       setState(() {
//         _selectedDevice = null;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Disconnect failed: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> _onPrintReceipt() async {
//     if (_selectedDevice == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('No printer selected')),
//         );
//       }
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       // Ensure device is connected
//       if (!_selectedDevice!.isConnected) {
//         await _selectedDevice!.connect();
//       }
//
//       // Get services
//       List<BluetoothService> services = await _selectedDevice!.discoverServices();
//       Uint8List bytes = Uint8List.fromList(_buildReceiptBytes());
//
//       // Try common ESC/POS service UUIDs
//       const escPosServiceUuids = [
//         '000018F0-0000-1000-8000-00805F9B34FB',
//         'E7810A71-73AE-499D-8C15-FAA9AEF0C3F2',
//       ];
//
//       bool printed = false;
//
//       for (var service in services) {
//         if (escPosServiceUuids.contains(service.uuid.toString().toUpperCase())) {
//           for (var characteristic in service.characteristics) {
//             if (characteristic.properties.write ||
//                 characteristic.properties.writeWithoutResponse) {
//               await characteristic.write(bytes, withoutResponse: true);
//               printed = true;
//               break;
//             }
//           }
//         }
//         if (printed) break;
//       }
//
//       // Fallback: Try all characteristics if not found in specific services
//       if (!printed) {
//         for (var service in services) {
//           for (var characteristic in service.characteristics) {
//             if (characteristic.properties.write ||
//                 characteristic.properties.writeWithoutResponse) {
//               try {
//                 await characteristic.write(bytes, withoutResponse: true);
//                 printed = true;
//                 break;
//               } catch (e) {
//                 debugPrint('Print attempt failed: $e');
//               }
//             }
//           }
//           if (printed) break;
//         }
//       }
//
//       if (printed && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Receipt printed successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         throw Exception('Failed to find a suitable printer characteristic');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Print failed: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   String _getDeviceName(BluetoothDevice device) {
//     return device.platformName.isNotEmpty
//         ? device.platformName
//         : device.advName.isNotEmpty
//         ? device.advName
//         : device.localName.isNotEmpty
//         ? device.localName
//         : 'Unknown Device';
//   }
//
//   List<int> _buildReceiptBytes() {
//     final vm = widget.viewModel;
//     final summary = vm.summary!;
//     List<int> bytes = [];
//
//     // ESC/POS commands
//     bytes.addAll([0x1B, 0x40]); // Initialize printer
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\x1B\x21\x20'.codeUnits); // Bold, double height
//     bytes.addAll('TASTY RESTAURANT\n'.codeUnits);
//
//     // Normal text
//     bytes.addAll('\x1B\x21\x00'.codeUnits);
//     bytes.addAll('123 Main Street, Food City\n'.codeUnits);
//     bytes.addAll('Phone: +1 234 567 8900\n'.codeUnits);
//     bytes.addAll(('-' * 32).codeUnits); // Divider
//
//     // Left align for order info
//     bytes.addAll('\x1B\x61\x00'.codeUnits);
//     bytes.addAll('Order No: ${widget.orderNo ?? '--'}\n'.codeUnits);
//     bytes.addAll(
//         'Table No: ${widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}'}\n'
//             .codeUnits);
//     bytes.addAll(
//         'Date: ${DateTime.now().toString().substring(0, 16)}\n'.codeUnits);
//     bytes.addAll(('-' * 32).codeUnits);
//
//     // Table header
//     bytes.addAll('Item                     Qty   Price\n'.codeUnits);
//     bytes.addAll(('-' * 32).codeUnits);
//
//     for (var item in vm.orderedItems) {
//       final itemName = (item.foodItem ?? '').padRight(22).substring(0, 22);
//       final qty = (item.quantity ?? 0).toString().padLeft(3);
//       final price = '₹${item.totalPrice ?? 0}'.padLeft(7);
//       bytes.addAll('$itemName $qty $price\n'.codeUnits);
//     }
//
//     bytes.addAll(('-' * 32).codeUnits);
//
//     // Summary
//     bytes.addAll('Sub Total:'.padRight(28).codeUnits);
//     bytes.addAll('₹${summary.subTotal}\n'.codeUnits);
//
//     bytes.addAll('VAT (${summary.vatPercentage}%):'.padRight(28).codeUnits);
//     bytes.addAll('₹${summary.vat}\n'.codeUnits);
//
//     bytes.addAll('\x1B\x45\x01'.codeUnits); // Bold on
//     bytes.addAll('Total Amount:'.padRight(28).codeUnits);
//     bytes.addAll('₹${summary.totalAmount}\n'.codeUnits);
//     bytes.addAll('\x1B\x45\x00'.codeUnits); // Bold off
//
//     bytes.addAll(('-' * 32).codeUnits);
//
//     // Thank you
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\nThank you for dining with us!\n'.codeUnits);
//     bytes.addAll('Please visit again\n\n\n'.codeUnits);
//
//     // Cut paper
//     bytes.addAll([0x1D, 0x56, 0x41, 0x10]);
//
//     return bytes;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Bluetooth Printer"),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Status and Actions
//             if (_selectedDevice != null)
//               Card(
//                 child: ListTile(
//                   title: Text(
//                     'Connected: ${_getDeviceName(_selectedDevice!)}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(_selectedDevice!.remoteId.str),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.print),
//                         onPressed: _isLoading ? null : _onPrintReceipt,
//                         tooltip: 'Print Receipt',
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.link_off),
//                         onPressed: _isLoading ? null : _onDisconnectDevice,
//                         tooltip: 'Disconnect',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//             // Scan Button
//             ElevatedButton.icon(
//               icon: _isScanning
//                   ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                 ),
//               )
//                   : const Icon(Icons.bluetooth_searching),
//               label: Text(_isScanning ? 'Scanning...' : 'Scan Printers'),
//               onPressed: _isLoading ? null : _onScanPressed,
//             ),
//
//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 8),
//
//             // Device List
//             if (_bluetoothDevices.isEmpty)
//               const Expanded(
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.bluetooth, size: 64, color: Colors.blue),
//                       SizedBox(height: 16),
//                       Text('No printers found'),
//                       Text('Press scan to search for devices',
//                           style: TextStyle(color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//               )
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _bluetoothDevices.length,
//                   itemBuilder: (context, index) {
//                     final device = _bluetoothDevices[index];
//                     final isSelected = _selectedDevice?.remoteId == device.remoteId;
//                     final isConnecting = _loadingAtIndex == index && _isLoading;
//
//                     return Card(
//                       elevation: 2,
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       child: ListTile(
//                         leading: isSelected
//                             ? const Icon(Icons.bluetooth_connected,
//                             color: Colors.blue)
//                             : const Icon(Icons.bluetooth),
//                         title: Text(_getDeviceName(device)),
//                         subtitle: Text(device.remoteId.str),
//                         trailing: isConnecting
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                           onPressed: () => _onSelectDevice(index),
//                           child: Text(
//                             isSelected ? 'Connected' : 'Connect',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isSelected
//                                 ? Colors.green
//                                 : Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }

class EpsonPrinterPage extends StatefulWidget {
  const EpsonPrinterPage({super.key});

  @override
  State<EpsonPrinterPage> createState() => _EpsonPrinterPageState();
}

class _EpsonPrinterPageState extends State<EpsonPrinterPage> {
  bt.BlueThermalPrinter bluetooth = bt.BlueThermalPrinter.instance;

  List<bt.BluetoothDevice> devices = [];
  bt.BluetoothDevice? selectedDevice;

  bool _isLoading = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkBluetooth();
  }

  Future<void> _checkBluetooth() async {
    bool? isOn = await bluetooth.isOn;
    if (isOn == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bluetooth is off. Please turn it on.")),
      );
    }
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isLoading = true;
      devices.clear();
    });

    // simulate scanning time
    await Future.delayed(const Duration(seconds: 2));

    List<bt.BluetoothDevice> bondedDevices =
    await bluetooth.getBondedDevices();

    List<bt.BluetoothDevice> epsonDevices = bondedDevices
        .where((d) =>
    d.name != null && d.name!.toLowerCase().contains("epson"))
        .toList();

    setState(() {
      devices = epsonDevices;
      _isLoading = false;
    });

    if (epsonDevices.isEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No Epson printers found.")),
        );
      });
    }
  }


  Future<void> _connectToDevice(bt.BluetoothDevice device) async {
    setState(() {
      _isLoading = true;
    });

    await bluetooth.connect(device).then((connected) {
      setState(() {
        selectedDevice = device;
        _isConnected = connected ?? false;
        _isLoading = false;
      });

      if (_isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connected to ${device.name}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to connect to ${device.name}")),
        );
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }

  Future<void> _disconnect() async {
    await bluetooth.disconnect();
    setState(() {
      selectedDevice = null;
      _isConnected = false;
    });
  }

  Future<void> _printTestReceipt() async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No printer connected")),
      );
      return;
    }

    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.writeBytes(Uint8List.fromList([0x1B, 0x40])); // Initialize printer
        bluetooth.printNewLine();
        bluetooth.printCustom("TASTY RESTAURANT", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Order No:", "1234", 1);
        bluetooth.printLeftRight("Table No:", "5", 1);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printLeftRight("Burger", "₹120", 1);
        bluetooth.printLeftRight("Fries", "₹80", 1);
        bluetooth.printCustom("-------------------------------", 1, 1);
        bluetooth.printLeftRight("TOTAL", "₹200", 2);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You!", 1, 1);
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Epson Printer Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _scanDevices,
              child: Text(_isLoading ? "Scanning..." : "Scan Epson Printers"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: devices.isEmpty
                  ? const Center(child: Text("No printers found"))
                  : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  bt.BluetoothDevice device = devices[index];
                  bool isSelected =
                      selectedDevice?.address == device.address;
                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth,
                      color: isSelected ? Colors.green : Colors.grey,
                    ),
                    title: Text(device.name ?? 'Unknown'),
                    subtitle: Text(device.address ?? ''),
                    trailing: ElevatedButton(
                      onPressed: () => _connectToDevice(device),
                      child:
                      Text(isSelected ? "Connected" : "Connect"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isConnected ? _printTestReceipt : null,
              icon: const Icon(Icons.print),
              label: const Text("Print Test Receipt"),
            ),
            const SizedBox(height: 10),
            if (_isConnected)
              ElevatedButton.icon(
                onPressed: _disconnect,
                icon: const Icon(Icons.link_off),
                label: const Text("Disconnect"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              )
          ],
        ),
      ),
    );
  }
}

// class BluetoothPrinterPage extends StatefulWidget {
//   final String tableNo;
//   final String orderNo;
//   final StaffSelectProductViewModel viewModel;
//   const BluetoothPrinterPage(
//       {required this.tableNo,
//         required this.viewModel,
//         required this.orderNo,
//         super.key});
//
//   @override
//   State<BluetoothPrinterPage> createState() => _BluetoothPrinterPageState();
// }
//
// class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
//   List<BluetoothDevice> _bluetoothDevices = <BluetoothDevice>[];
//   BluetoothDevice? _selectedDevice;
//   bool _isLoading = false;
//   bool _isScanning = false;
//   int _loadingAtIndex = -1;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissions();
//   }
//
//   Future<void> _checkPermissions() async {
//     if (Platform.isAndroid) {
//       Map<Permission, PermissionStatus> statuses = await [
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//         Permission.location,
//       ].request();
//
//       if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
//           statuses[Permission.bluetoothConnect] != PermissionStatus.granted ||
//           statuses[Permission.location] != PermissionStatus.granted) {
//         if (kDebugMode) {
//           print('Permissions not granted');
//         }
//       }
//     }
//   }
//
//   Future<void> _onScanPressed() async {
//     if (_isScanning) return;
//
//     setState(() {
//       _isLoading = true;
//       _isScanning = true;
//       _bluetoothDevices.clear();
//     });
//
//     try {
//       // Start scanning
//       await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
//
//       // Listen for scan results
//       FlutterBluePlus.scanResults.listen((results) {
//         setState(() {
//           _bluetoothDevices = results.map((result) => result.device).toList();
//           _isLoading = false;
//         });
//       });
//
//       // Stop scanning after timeout
//       await Future.delayed(const Duration(seconds: 10));
//       await FlutterBluePlus.stopScan();
//
//       setState(() {
//         _isScanning = false;
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error scanning: $e');
//       }
//       setState(() {
//         _isScanning = false;
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _onPrintReceipt() async {
//     if (_selectedDevice == null) return;
//
//     try {
//       List<BluetoothService> services =
//       await _selectedDevice!.discoverServices();
//       List<int> bytes = _buildReceiptBytes();
//
//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic c in service.characteristics) {
//           if (c.properties.write || c.properties.writeWithoutResponse) {
//             await c.write(bytes, withoutResponse: true);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text('Receipt sent to Bluetooth printer!'),
//                   backgroundColor: Colors.green),
//             );
//             return;
//           }
//         }
//       }
//
//       // For now, just show a success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'Print functionality will be implemented in the next version'),
//           backgroundColor: Colors.blue,
//         ),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error printing: $e');
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<void> _onSelectDevice(int index) async {
//     setState(() {
//       _isLoading = true;
//       _loadingAtIndex = index;
//     });
//
//     try {
//       final BluetoothDevice device = _bluetoothDevices[index];
//
//       // Connect to device
//       await device.connect(timeout: const Duration(seconds: 10));
//
//       setState(() {
//         _selectedDevice = device;
//         _isLoading = false;
//         _loadingAtIndex = -1;
//       });
//
//       if (kDebugMode) {
//         print('Connected to ${device.platformName}');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error connecting: $e');
//       }
//       setState(() {
//         _isLoading = false;
//         _loadingAtIndex = -1;
//       });
//     }
//   }
//
//   Future<void> _onDisconnectDevice() async {
//     if (_selectedDevice != null) {
//       try {
//         await _selectedDevice!.disconnect();
//         setState(() {
//           _selectedDevice = null;
//         });
//         if (kDebugMode) {
//           print('Disconnected from device');
//         }
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error disconnecting: $e');
//         }
//       }
//     }
//   }
//
//   List<int> _buildReceiptBytes() {
//     final vm = widget.viewModel;
//     final summary = vm.summary!;
//     List<int> bytes = [];
//
//     // ESC/POS: Init, center align, bold double height
//     bytes.addAll([0x1B, 0x40]); // Initialize
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\x1B\x21\x20'.codeUnits); // Bold, double height
//     bytes.addAll('TASTY RESTAURANT\n'.codeUnits);
//
//     // Normal text
//     bytes.addAll('\x1B\x21\x00'.codeUnits);
//     bytes.addAll('123 Main Street, Food City\n'.codeUnits);
//     bytes.addAll('Phone: +1 234 567 8900\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits); // Divider
//
//     // Left align for order info
//     bytes.addAll('\x1B\x61\x00'.codeUnits);
//     bytes.addAll('Order No: ${widget.orderNo ?? '--'}\n'.codeUnits);
//     bytes.addAll(
//         'Table No: ${widget.tableNo == '0' ? 'Take Away' : 'Table ${widget.tableNo}'}\n'
//             .codeUnits);
//     bytes.addAll(
//         'Date: ${DateTime.now().toString().substring(0, 16)}\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Table header
//     bytes.addAll('Item                          Qty   Price\n'.codeUnits);
//     bytes.addAll(('-' * 48).codeUnits);
//
//     for (var item in vm.orderedItems) {
//       final itemName = (item.foodItem ?? '').padRight(28).substring(0, 28);
//       final qty = (item.quantity ?? 0).toString().padLeft(3);
//       final price = '₹${item.totalPrice ?? 0}'.padLeft(7);
//       bytes.addAll('$itemName $qty $price\n'.codeUnits);
//     }
//
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Summary
//     bytes.addAll('Sub Total:'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.subTotal}\n'.codeUnits);
//
//     bytes.addAll('VAT (${summary.vatPercentage}%):'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.vat}\n'.codeUnits);
//
//     bytes.addAll('\x1B\x45\x01'.codeUnits); // Bold on
//     bytes.addAll('Total Amount:'.padRight(40).codeUnits);
//     bytes.addAll('₹${summary.totalAmount}\n'.codeUnits);
//     bytes.addAll('\x1B\x45\x00'.codeUnits); // Bold off
//
//     bytes.addAll(('-' * 48).codeUnits);
//
//     // Thank you
//     bytes.addAll('\x1B\x61\x01'.codeUnits); // Center align
//     bytes.addAll('\nThank you for dining with us!\n'.codeUnits);
//     bytes.addAll('Please visit again\n\n\n'.codeUnits);
//
//     // Cut
//     bytes.addAll([0x1D, 0x56, 0x41, 0x10]);
//
//     return bytes;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Select WiFi Printer"),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton.icon(
//               icon: const Icon(Icons.bluetooth_audio_sharp),
//               label: const Text("Print Now"),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _onScanPressed();
//               },
//             ),
//             // Bluetooth Printer Section
//             Text(
//               'Bluetooth Printers',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             _isLoading && _bluetoothDevices.isEmpty
//                 ? const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               ),
//             )
//                 : _bluetoothDevices.isNotEmpty
//                 ? Column(
//               children: List<Widget>.generate(
//                   _bluetoothDevices.length, (int index) {
//                 final device = _bluetoothDevices[index];
//                 final isSelected =
//                     _selectedDevice?.remoteId == device.remoteId;
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   child: ListTile(
//                     title: Text(
//                       (device.localName?.isNotEmpty ?? false)
//                           ? device.localName!
//                           : (device.advName?.isNotEmpty ?? false)
//                           ? device.advName!
//                           : (device.name.isNotEmpty)
//                           ? device.name
//                           : (device.platformName.isNotEmpty)
//                           ? device.platformName
//                           : 'Unknown Device',
//                       style: TextStyle(
//                         color:
//                         isSelected ? Colors.blue : Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     subtitle: Text(
//                       device.remoteId.toString(),
//                       style: TextStyle(
//                         color: isSelected
//                             ? Colors.blueGrey
//                             : Colors.grey,
//                       ),
//                     ),
//                     trailing: _loadingAtIndex == index && _isLoading
//                         ? const SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(
//                         valueColor:
//                         AlwaysStoppedAnimation<Color>(
//                             Colors.blue),
//                       ),
//                     )
//                         : isSelected
//                         ? Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextButton(
//                           onPressed: _onPrintReceipt,
//                           child: const Text(
//                             'Print',
//                             style: TextStyle(
//                                 color: Colors.white),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all(
//                                 Colors.blue),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         TextButton(
//                           onPressed: _onDisconnectDevice,
//                           child: const Text(
//                             'Disconnect',
//                             style: TextStyle(
//                                 color: Colors.white),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor:
//                             MaterialStateProperty.all(
//                                 Colors.red),
//                           ),
//                         ),
//                       ],
//                     )
//                         : TextButton(
//                       onPressed: () =>
//                           _onSelectDevice(index),
//                       child: const Text(
//                         'Connect',
//                         style:
//                         TextStyle(color: Colors.white),
//                       ),
//                       style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(
//                             Colors.green),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             )
//                 : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const <Widget>[
//                   Icon(
//                     Icons.bluetooth_searching,
//                     size: 64,
//                     color: Colors.blue,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Scan for Bluetooth devices',
//                     style:
//                     TextStyle(fontSize: 24, color: Colors.blue),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Press the scan button to find nearby devices',
//                     style:
//                     TextStyle(fontSize: 14, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }
