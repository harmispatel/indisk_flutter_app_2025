// import 'package:flutter/material.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class PrinterScreen extends StatefulWidget {
//   @override
//   _PrinterScreenState createState() => _PrinterScreenState();
// }
//
// class _PrinterScreenState extends State<PrinterScreen> {
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   List<BluetoothDevice> devices = [];
//   BluetoothDevice? selectedDevice;
//   bool _connected = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initBluetooth();
//   }
//
//   Future<void> initBluetooth() async {
//     await Permission.bluetooth.request();
//     await Permission.location.request();
//
//     bool? isConnected = await bluetooth.isConnected;
//     List<BluetoothDevice> _devices = [];
//
//     try {
//       _devices = await bluetooth.getBondedDevices();
//     } catch (e) {
//       print("Error: $e");
//     }
//
//     setState(() {
//       devices = _devices;
//       _connected = isConnected ?? false;
//     });
//   }
//
//   void connectToPrinte// import 'package:flutter/material.dart';
// // import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // class PrinterScreen extends StatefulWidget {
// //   @override
// //   _PrinterScreenState createState() => _PrinterScreenState();
// // }
// //
// // class _PrinterScreenState extends State<PrinterScreen> {
// //   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
// //   List<BluetoothDevice> devices = [];
// //   BluetoothDevice? selectedDevice;
// //   bool _connected = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initBluetooth();
// //   }
// //
// //   Future<void> initBluetooth() async {
// //     await Permission.bluetooth.request();
// //     await Permission.location.request();
// //
// //     bool? isConnected = await bluetooth.isConnected;
// //     List<BluetoothDevice> _devices = [];
// //
// //     try {
// //       _devices = await bluetooth.getBondedDevices();
// //     } catch (e) {
// //       print("Error: $e");
// //     }
// //
// //     setState(() {
// //       devices = _devices;
// //       _connected = isConnected ?? false;
// //     });
// //   }
// //
// //   void connectToPrinter(BluetoothDevice device) async {
// //     await bluetooth.connect(device);
// //     setState(() {
// //       selectedDevice = device;
// //       _connected = true;
// //     });
// //   }
// //
// //   void testPrint() {
// //     if (selectedDevice != null && _connected) {
// //       bluetooth.printNewLine();
// //       bluetooth.printCustom("Test Print", 3, 1); // Size 3, Centered
// //       bluetooth.printNewLine();
// //       bluetooth.paperCut();
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Printer List")),
// //       body: Column(
// //         children: [
// //           ElevatedButton(
// //             onPressed: () => initBluetooth(),
// //             child: Text("Refresh Devices"),
// //           ),
// //           ...devices.map((device) => ListTile(
// //             title: Text(device.name ?? "Unknown"),
// //             subtitle: Text(device.address ?? ""),
// //             trailing: selectedDevice?.address == device.address
// //                 ? Icon(Icons.check, color: Colors.green)
// //                 : null,
// //             onTap: () => connectToPrinter(device),
// //           )),
// //           if (_connected)
// //             ElevatedButton(
// //               onPressed: testPrint,
// //               child: Text("Test Print"),
// //             )
// //         ],
// //       ),
// //     );
// //   }
// // }r(BluetoothDevice device) async {
//     await bluetooth.connect(device);
//     setState(() {
//       selectedDevice = device;
//       _connected = true;
//     });
//   }
//
//   void testPrint() {
//     if (selectedDevice != null && _connected) {
//       bluetooth.printNewLine();
//       bluetooth.printCustom("Test Print", 3, 1); // Size 3, Centered
//       bluetooth.printNewLine();
//       bluetooth.paperCut();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Printer List")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () => initBluetooth(),
//             child: Text("Refresh Devices"),
//           ),
//           ...devices.map((device) => ListTile(
//             title: Text(device.name ?? "Unknown"),
//             subtitle: Text(device.address ?? ""),
//             trailing: selectedDevice?.address == device.address
//                 ? Icon(Icons.check, color: Colors.green)
//                 : null,
//             onTap: () => connectToPrinter(device),
//           )),
//           if (_connected)
//             ElevatedButton(
//               onPressed: testPrint,
//               child: Text("Test Print"),
//             )
//         ],
//       ),
//     );
//   }
// }
