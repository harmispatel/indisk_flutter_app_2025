/// All Bluetooth Device Connect Done

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:convert';
import 'dart:typed_data';

class ConnectToPrinter1 extends StatefulWidget {
  const ConnectToPrinter1({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ConnectToPrinter1> createState() => _ConnectToPrinter1State();
}

class _ConnectToPrinter1State extends State<ConnectToPrinter1> {
  List<BluetoothDevice> _bluetoothDevices = <BluetoothDevice>[];
  BluetoothDevice? _selectedDevice;
  bool _isLoading = false;
  int _loadingAtIndex = -1;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (statuses[Permission.bluetoothScan] != PermissionStatus.granted ||
          statuses[Permission.bluetoothConnect] != PermissionStatus.granted ||
          statuses[Permission.location] != PermissionStatus.granted) {
        if (kDebugMode) {
          print('Permissions not granted');
        }
      }
    }
  }

  Future<void> _onScanPressed() async {
    if (_isScanning) return;

    final isBluetoothOn = await FlutterBluePlus.isOn;

    if (!isBluetoothOn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please turn on Bluetooth to scan for devices.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
      _isScanning = true;
      _bluetoothDevices.clear();
    });

    try {
      // Start scanning
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      // Listen for scan results
      // FlutterBluePlus.scanResults.listen((results) {
      //   setState(() {
      //     _bluetoothDevices = results.map((result) => result.device).toList();
      //     _isLoading = false;
      //   });
      // });
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!_bluetoothDevices
              .any((d) => d.remoteId == result.device.remoteId)) {
            setState(() {
              _bluetoothDevices.add(result.device);
            });
          }
        }
        setState(() {
          _isLoading = false;
        });
      });

      // Stop scanning after timeout
      await Future.delayed(const Duration(seconds: 10));
      await FlutterBluePlus.stopScan();
    } catch (e) {
      if (kDebugMode) {
        print('Error scanning: $e');
      }
    }

    setState(() {
      _isScanning = false;
      _isLoading = false;
    });
  }

  Future<void> _onSelectDevice(int index) async {
    setState(() {
      _isLoading = true;
      _loadingAtIndex = index;
    });

    try {
      final BluetoothDevice device = _bluetoothDevices[index];

      // Connect to device
      await device.connect(timeout: const Duration(seconds: 10));

      setState(() {
        _selectedDevice = device;
        _isLoading = false;
        _loadingAtIndex = -1;
      });

      if (kDebugMode) {
        print('Connected to ${device.platformName}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting: $e');
      }
      setState(() {
        _isLoading = false;
        _loadingAtIndex = -1;
      });
    }
  }

  Future<void> _onDisconnectDevice() async {
    if (_selectedDevice != null) {
      try {
        await _selectedDevice!.disconnect();
        setState(() {
          _selectedDevice = null;
        });
        if (kDebugMode) {
          print('Disconnected from device');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error disconnecting: $e');
        }
      }
    }
  }

  Future<void> _onPrintReceipt() async {
    if (_selectedDevice == null) return;

    try {
      List<BluetoothService> services =
          await _selectedDevice!.discoverServices();
      List<int> bytes = _buildRestaurantReceipt();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.properties.write || c.properties.writeWithoutResponse) {
            await c.write(bytes, withoutResponse: true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Receipt sent to Bluetooth printer!'),
                  backgroundColor: Colors.green),
            );
            return;
          }
        }
      }

      // // Discover services
      // List<BluetoothService> services = await _selectedDevice!.discoverServices();
      //
      // if (kDebugMode) {
      //   print('Found ${services.length} services');
      //   for (BluetoothService service in services) {
      //     print('Service: ${service.uuid}');
      //     for (BluetoothCharacteristic characteristic in service.characteristics) {
      //       print('  Characteristic: ${characteristic.uuid}');
      //       print('    Properties: ${characteristic.properties}');
      //     }
      //   }
      // }

      //For now, just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Print functionality will be implemented in the next version'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error printing: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bluetooth Printer Section
              Text(
                'Bluetooth Printers',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _isLoading && _bluetoothDevices.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )
                  : _bluetoothDevices.isNotEmpty
                      ? Column(
                          children: List<Widget>.generate(
                              _bluetoothDevices.length, (int index) {
                            final device = _bluetoothDevices[index];
                            final isSelected =
                                _selectedDevice?.remoteId == device.remoteId;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  (device.localName.isNotEmpty)
                                      ? device.localName
                                      : (device.advName.isNotEmpty)
                                          ? device.advName
                                          : (device.name.isNotEmpty)
                                              ? device.name
                                              : (device.platformName.isNotEmpty)
                                                  ? device.platformName
                                                  : 'Unknown Device',
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.blue : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  device.remoteId.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.blueGrey
                                        : Colors.grey,
                                  ),
                                ),
                                trailing: _loadingAtIndex == index && _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      )
                                    : isSelected
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                onPressed: _onPrintReceipt,
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blue),
                                                ),
                                                child: Text(
                                                  'Print',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              TextButton(
                                                onPressed: _onDisconnectDevice,
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red),
                                                ),
                                                child: const Text(
                                                  'Disconnect',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextButton(
                                            onPressed: () =>
                                                _onSelectDevice(index),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ),
                                            child: const Text(
                                              'Connect',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                              ),
                            );
                          }),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(
                                Icons.bluetooth_searching,
                                size: 64,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Scan for Bluetooth devices',
                                style:
                                    TextStyle(fontSize: 24, color: Colors.blue),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Press the scan button to find nearby devices',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _onScanPressed,
        backgroundColor: _isLoading ? Colors.grey : Colors.blue,
        tooltip: 'Scan Bluetooth',
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }

  List<int> _buildRestaurantReceipt() {
    List<int> bytes = [];

    // Header
    bytes.addAll('\x1B\x21\x30'.codeUnits); // Bold double height/width
    bytes.addAll('The Food Place\n'.codeUnits);
    bytes.addAll('\x1B\x21\x00'.codeUnits); // Reset style
    // bytes.addAll('123 Flutter Blvd.\nCityville, FL\n');
    bytes.addAll('------------------------------\n'.codeUnits);

    // Items
    bytes.addAll('Burger x2        \$10.00\n'.codeUnits);
    bytes.addAll('Fries x1         \$3.50\n'.codeUnits);
    bytes.addAll('Soda x2          \$4.00\n'.codeUnits);
    bytes.addAll('------------------------------\n'.codeUnits);

    // Totals
    bytes.addAll('Subtotal:        \$17.50\n'.codeUnits);
    bytes.addAll('Tax (8%):        \$1.40\n'.codeUnits);
    bytes.addAll('Total:           \$18.90\n'.codeUnits);

    bytes.addAll('------------------------------\n'.codeUnits);
    bytes.addAll('Thank you!\nVisit again!\n'.codeUnits);
    bytes.addAll([0x0A]); // Line feed
    bytes.addAll([0x1D, 0x56, 0x41, 0x10]); // Partial cut

    return bytes;
  }
}

/// Prenter Id Bluetooth Device Connect

class ConnectToPrinter extends StatefulWidget {
  const ConnectToPrinter({super.key});

  @override
  State<ConnectToPrinter> createState() => _ConnectToPrinterState();
}

class _ConnectToPrinterState extends State<ConnectToPrinter> {
  List availableBluetoothDevices = [];
  bool connected = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getBluetooth() async {
    try {
      final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
      if (bluetooths != null) {
        setState(() {
          availableBluetoothDevices = bluetooths;
        });
      }
    } catch (e) {
      print("Error fetching bluetooth devices: $e");
    }
  }

  Future<void> setConnect(String mac) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    context.loaderOverlay.show();

    String? status = await BluetoothThermalPrinter.connectionStatus;
    if (status == "true") {
      prefs.setString('printer', mac);
      prefs.setBool('printerConnected', true);
      context.loaderOverlay.hide();
      showDialogueBox("Success", "Printer already connected.");
      return;
    }

    final result = await BluetoothThermalPrinter.connect(mac);
    context.loaderOverlay.hide();

    if (result == "true") {
      prefs.setString('printer', mac);
      prefs.setBool('printerConnected', true);
      setState(() {
        connected = true;
      });
      showDialogueBox("Success", "Printer connected successfully.");
    } else {
      showDialogueBox("Error", "Unable to connect to printer.");
    }
  }

  String getName(String name) {
    String pname = name.split("#")[0];
    String address = name.split("#")[1];
    if (address == "00:01:90:57:EB:FD") {
      return "Epson TM-m30II Printer";
    } else if (pname == "BlueTooth Printer") {
      return "Generic Printer";
    } else {
      return pname;
    }
  }

  void showDialogueBox(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connect To Printer"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1. First pair the printer with your mobile's Bluetooth settings.\n"
                "2. Then press 'Search' to list paired devices.\n"
                "3. Tap on a device to connect.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: getBluetooth,
                icon: const Icon(Icons.search),
                label: const Text("Search Devices"),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: availableBluetoothDevices.length,
                  itemBuilder: (context, index) {
                    final device = availableBluetoothDevices[index];
                    String mac = device.split("#")[1];
                    return ListTile(
                      leading: const Icon(Icons.print),
                      title: Text(getName(device)),
                      subtitle: Text(mac),
                      trailing: ElevatedButton(
                        onPressed: () => setConnect(mac),
                        child: const Text("Connect"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 2 Prenter Id Bluetooth Device Connect

class ConnectToPrinterView extends StatefulWidget {
  const ConnectToPrinterView({Key? key}) : super(key: key);

  @override
  State<ConnectToPrinterView> createState() => _ConnectToPrinterViewState();
}

class _ConnectToPrinterViewState extends State<ConnectToPrinterView> {
  bool connected = false;
  List availableBluetoothDevices = [];

  @override
  void initState() {
    super.initState();
    getBluetooth();
  }

  Future<void> getBluetooth() async {
    try {
      final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
      setState(() {
        availableBluetoothDevices = bluetooths ?? [];
      });
    } catch (e) {
      print("Error scanning: $e");
    }
  }

  Future<void> connectToPrinter(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);

    if (result == "true") {  // Compare with string "true"
      setState(() {
        connected = true;
      });
      showMessage("Connected", "Printer connected successfully.");
      printTestReceipt();
    } else {
      showMessage("Error", "Could not connect to printer: $result");
    }
  }

  Future<void> printTestReceipt() async {
    try {
      String textToPrint = """
        The Food Place
        
        Burger x2       \$10.00
        Fries x1        \$3.50
        -----------------------------
        Total:          \$13.50
        
        Thank you!
        """;

      // Send print command
      final String? result = await BluetoothThermalPrinter.writeBytes(
          Uint8List.fromList(utf8.encode(textToPrint))
      );

      // Handle response
      if (result?.toLowerCase() == "success" || result?.toLowerCase() == "true") {
        showMessage("Success", "Receipt printed successfully");
      } else {
        showMessage("Error", "Printing failed: ${result ?? 'Unknown error'}");
      }
    } catch (e) {
      showMessage("Error", "Printing exception: ${e.toString()}");
    }
  }

  // Future<void> printTestReceipt() async {
  //   List<int> bytes = [];
  //
  //   bytes += Uint8List.fromList(utf8.encode("The Food Place\n\n"));
  //   bytes += Uint8List.fromList(utf8.encode("Burger x2       \$10.00\n"));
  //   bytes += Uint8List.fromList(utf8.encode("Fries x1        \$3.50\n"));
  //   bytes += Uint8List.fromList(utf8.encode("-----------------------------\n"));
  //   bytes += Uint8List.fromList(utf8.encode("Total:          \$13.50\n\n"));
  //   bytes += Uint8List.fromList(utf8.encode("Thank you!\n\n\n"));
  //
  //   final result = await BluetoothThermalPrinter.writeBytes(bytes);
  //   print("Print Result: $result");
  // }

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect to Printer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getBluetooth,
              child: Text("Search Bluetooth Devices"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: availableBluetoothDevices.length,
                itemBuilder: (context, index) {
                  String device = availableBluetoothDevices[index];
                  List<String> parts = device.split("#");
                  String name = parts[0];
                  String mac = parts[1];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(mac),
                    trailing: const Icon(Icons.bluetooth),
                    onTap: () => connectToPrinter(mac),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'dart:convert';
// import 'dart:typed_data';
//
// // class ConnectToPrinter extends StatefulWidget {
// //   const ConnectToPrinter({super.key});
// //
// //   @override
// //   State<ConnectToPrinter> createState() => _ConnectToPrinterState();
// // }
// //
// // class _ConnectToPrinterState extends State<ConnectToPrinter> {
// //   List availableBluetoothDevices = [];
// //   bool connected = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   Future<void> getBluetooth() async {
// //     try {
// //       final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
// //       if (bluetooths != null) {
// //         setState(() {
// //           availableBluetoothDevices = bluetooths;
// //         });
// //       }
// //     } catch (e) {
// //       print("Error fetching bluetooth devices: $e");
// //     }
// //   }
// //
// //   Future<void> setConnect(String mac) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     context.loaderOverlay.show();
// //
// //     String? status = await BluetoothThermalPrinter.connectionStatus;
// //     if (status == "true") {
// //       prefs.setString('printer', mac);
// //       prefs.setBool('printerConnected', true);
// //       context.loaderOverlay.hide();
// //       showDialogueBox("Success", "Printer already connected.");
// //       return;
// //     }
// //     final result = await BluetoothThermalPrinter.connect(mac);
// //     context.loaderOverlay.hide();
// //     if (result == "true") {
// //       prefs.setString('printer', mac);
// //       prefs.setBool('printerConnected', true);
// //       setState(() {
// //         connected = true;
// //       });
// //       showDialogueBox("Success", "Printer connected successfully.");
// //     } else {
// //       showDialogueBox("Error", "Unable to connect to printer.");
// //     }
// //   }
// //
// //   String getName(String name) {
// //     String pname = name.split("#")[0];
// //     String address = name.split("#")[1];
// //     if (address == "00:01:90:57:EB:FD") {
// //       return "Epson TM-m30II Printer";
// //     } else if (pname == "BlueTooth Printer") {
// //       return "Generic Printer";
// //     } else {
// //       return pname;
// //     }
// //   }
// //
// //   void showDialogueBox(String title, String message) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text(title),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("OK"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return LoaderOverlay(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Connect To Printer"),
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 "1. First pair the printer with your mobile's Bluetooth settings.\n"
// //                 "2. Then press 'Search' to list paired devices.\n"
// //                 "3. Tap on a device to connect.",
// //                 style: TextStyle(fontSize: 14),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton.icon(
// //                 onPressed: getBluetooth,
// //                 icon: const Icon(Icons.search),
// //                 label: const Text("Search Devices"),
// //               ),
// //               const SizedBox(height: 20),
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: availableBluetoothDevices.length,
// //                   itemBuilder: (context, index) {
// //                     final device = availableBluetoothDevices[index];
// //                     String mac = device.split("#")[1];
// //                     return ListTile(
// //                       leading: const Icon(Icons.print),
// //                       title: Text(getName(device)),
// //                       subtitle: Text(mac),
// //                       trailing: ElevatedButton(
// //                         onPressed: () => setConnect(mac),
// //                         child: const Text("Connect"),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class ConnectToPrinter extends StatefulWidget {
//   const ConnectToPrinter({super.key});
//
//   @override
//   State<ConnectToPrinter> createState() => _ConnectToPrinterState();
// }
//
// class _ConnectToPrinterState extends State<ConnectToPrinter> {
//   List availableBluetoothDevices = [];
//   bool connected = false;
//   String? selectedMac;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<void> getBluetooth() async {
//     try {
//       final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
//       if (bluetooths != null) {
//         setState(() {
//           availableBluetoothDevices = bluetooths;
//         });
//       }
//     } catch (e) {
//       print("Error fetching bluetooth devices: $e");
//     }
//   }
//
//   Future<void> setConnect(String mac) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     context.loaderOverlay.show();
//
//     String? status = await BluetoothThermalPrinter.connectionStatus;
//     if (status == "true") {
//       prefs.setString('printer', mac);
//       prefs.setBool('printerConnected', true);
//       context.loaderOverlay.hide();
//       setState(() {
//         connected = true;
//         selectedMac = mac;
//       });
//       showDialogueBox("Success", "Printer already connected.");
//       return;
//     }
//
//     final result = await BluetoothThermalPrinter.connect(mac);
//     context.loaderOverlay.hide();
//     if (result == "true") {
//       prefs.setString('printer', mac);
//       prefs.setBool('printerConnected', true);
//       setState(() {
//         connected = true;
//         selectedMac = mac;
//       });
//       showDialogueBox("Success", "Printer connected successfully.");
//     } else {
//       showDialogueBox("Error", "Unable to connect to printer.");
//     }
//   }
//
//   String getName(String name) {
//     String pname = name.split("#")[0];
//     String address = name.split("#")[1];
//     if (address == "00:01:90:57:EB:FD") {
//       return "Epson TM-m30II Printer";
//     } else if (pname == "BlueTooth Printer") {
//       return "Generic Printer";
//     } else {
//       return pname;
//     }
//   }
//
//   Future<void> printTest() async {
//     try {
//       String? status = await BluetoothThermalPrinter.connectionStatus;
//       if (status == "true") {
//         await BluetoothThermalPrinter.writeBytes(utf8.encode("\n"));
//         await BluetoothThermalPrinter.writeBytes(utf8.encode("🧾 INVOICE\n"));
//         await BluetoothThermalPrinter.writeBytes(
//             utf8.encode("Date: 18-07-2025\n"));
//         await BluetoothThermalPrinter.writeBytes(
//             utf8.encode("Customer: John Doe\n"));
//         await BluetoothThermalPrinter.writeBytes(
//             utf8.encode("Amount: ₹1,500\n"));
//         await BluetoothThermalPrinter.writeBytes(
//             utf8.encode("\nThank you!\n\n\n"));
//       } else {
//         showDialogueBox("Error", "Printer not connected.");
//       }
//     } catch (e) {
//       print("Print error: $e");
//       showDialogueBox("Error", "Failed to print: $e");
//     }
//   }
//
//   void showDialogueBox(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LoaderOverlay(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Connect To Printer"),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "1. First pair the printer with your mobile's Bluetooth settings.\n"
//                     "2. Then press 'Search' to list paired devices.\n"
//                     "3. Tap on a device to connect.",
//                 style: TextStyle(fontSize: 14),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: getBluetooth,
//                 icon: const Icon(Icons.search),
//                 label: const Text("Search Devices"),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: availableBluetoothDevices.length,
//                   itemBuilder: (context, index) {
//                     final device = availableBluetoothDevices[index];
//                     String mac = device.split("#")[1];
//                     return ListTile(
//                       leading: const Icon(Icons.print),
//                       title: Text(getName(device)),
//                       subtitle: Text(mac),
//                       trailing: ElevatedButton(
//                         onPressed: () => setConnect(mac),
//                         child: const Text("Connect"),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (connected)
//                 Center(
//                   child: ElevatedButton.icon(
//                     icon: const Icon(Icons.print),
//                     label: const Text("Print Test"),
//                     onPressed: printTest,
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// 2 Prenter Id Bluetooth Device Connect
//
// class ConnectToPrinterView extends StatefulWidget {
//   const ConnectToPrinterView({Key? key}) : super(key: key);
//
//   @override
//   State<ConnectToPrinterView> createState() => _ConnectToPrinterViewState();
// }
//
// class _ConnectToPrinterViewState extends State<ConnectToPrinterView> {
//   bool connected = false;
//   List availableBluetoothDevices = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getBluetooth();
//   }
//
//   Future<void> getBluetooth() async {
//     try {
//       final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
//       setState(() {
//         availableBluetoothDevices = bluetooths ?? [];
//       });
//     } catch (e) {
//       print("Error scanning: $e");
//     }
//   }
//
//   Future<void> connectToPrinter(String mac) async {
//     final String? result = await BluetoothThermalPrinter.connect(mac);
//     if (result == "true") {
//       setState(() {
//         connected = true;
//       });
//       showMessage("Connected", "Printer connected successfully.");
//       //printTestReceipt(); // auto print after connect
//     } else {
//       showMessage("Error", "Could not connect to printer.");
//     }
//   }
//
//   Future<void> printTestReceipt() async {
//     try {
//       final profile = await CapabilityProfile.load();
//       final generator = Generator(PaperSize.mm80, profile);
//       List<int> bytes = [];
//
//       bytes += generator.text('🧾 THE FOOD PLACE',
//           styles: const PosStyles(
//               bold: true, align: PosAlign.center, height: PosTextSize.size2));
//
//       bytes += generator.text('------------------------------');
//
//       bytes += generator.text('Burger x2              \$10.00');
//       bytes += generator.text('Fries x1               \$3.50');
//
//       bytes += generator.text('------------------------------');
//
//       bytes += generator.text('TOTAL:                 \$13.50',
//           styles: const PosStyles(bold: true, align: PosAlign.right));
//
//       bytes += generator.feed(2);
//       bytes += generator.text('Thank you!',
//           styles: const PosStyles(align: PosAlign.center));
//       bytes += generator.feed(3);
//       bytes += generator.cut();
//
//       final result =
//       await BluetoothThermalPrinter.writeBytes(Uint8List.fromList(bytes));
//       print("Printed result: $result");
//     } catch (e) {
//       print("Error printing receipt: $e");
//       showMessage("Error", "Failed to print receipt.");
//     }
//   }
//
//   void showMessage(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context), child: Text("OK")),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Connect to Printer"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: getBluetooth,
//               child: Text("Search Bluetooth Devices"),
//             ),
//             const SizedBox(height: 10),
//
//             Expanded(
//               child: ListView.builder(
//                 itemCount: availableBluetoothDevices.length,
//                 itemBuilder: (context, index) {
//                   String device = availableBluetoothDevices[index];
//                   List<String> parts = device.split("#");
//                   String name = parts[0];
//                   String mac = parts[1];
//
//                   return ListTile(
//                     title: Text(name),
//                     subtitle: Text(mac),
//                     trailing: const Icon(Icons.bluetooth),
//                     onTap: () => connectToPrinter(mac),
//                   );
//                 },
//               ),
//             ),
//
//             // ✅ Print Button (only if connected)
//             if (connected)
//               ElevatedButton.icon(
//                 icon: Icon(Icons.print),
//                 label: Text("Print Receipt"),
//                 onPressed: printTestReceipt,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // class ConnectToPrinterView extends StatefulWidget {
// //   const ConnectToPrinterView({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ConnectToPrinterView> createState() => _ConnectToPrinterViewState();
// // }
// //
// // class _ConnectToPrinterViewState extends State<ConnectToPrinterView> {
// //   bool connected = false;
// //   List availableBluetoothDevices = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     getBluetooth();
// //   }
// //
// //   Future<void> getBluetooth() async {
// //     try {
// //       final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
// //       setState(() {
// //         availableBluetoothDevices = bluetooths ?? [];
// //       });
// //     } catch (e) {
// //       print("Error scanning: $e");
// //     }
// //   }
// //
// //   Future<void> connectToPrinter(String mac) async {
// //     final String? result = await BluetoothThermalPrinter.connect(mac);
// //     if (result == "true") {
// //       setState(() {
// //         connected = true;
// //       });
// //       showMessage("Connected", "Printer connected successfully.");
// //       printTestReceipt(); // auto print after connect
// //     } else {
// //       showMessage("Error", "Could not connect to printer.");
// //     }
// //   }
// //
// //   Future<void> printTestReceipt() async {
// //     List<int> bytes = [];
// //
// //     bytes += Uint8List.fromList(utf8.encode("The Food Place\n\n"));
// //     bytes += Uint8List.fromList(utf8.encode("Burger x2       \$10.00\n"));
// //     bytes += Uint8List.fromList(utf8.encode("Fries x1        \$3.50\n"));
// //     bytes += Uint8List.fromList(utf8.encode("-----------------------------\n"));
// //     bytes += Uint8List.fromList(utf8.encode("Total:          \$13.50\n\n"));
// //     bytes += Uint8List.fromList(utf8.encode("Thank you!\n\n\n"));
// //
// //     final result = await BluetoothThermalPrinter.writeBytes(bytes);
// //     print("Print Result: $result");
// //   }
// //
// //   void showMessage(String title, String message) {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text(title),
// //         content: Text(message),
// //         actions: [
// //           TextButton(
// //               onPressed: () => Navigator.pop(context), child: Text("OK")),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Connect to Printer"),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             ElevatedButton(
// //               onPressed: getBluetooth,
// //               child: Text("Search Bluetooth Devices"),
// //             ),
// //             const SizedBox(height: 10),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: availableBluetoothDevices.length,
// //                 itemBuilder: (context, index) {
// //                   String device = availableBluetoothDevices[index];
// //                   List<String> parts = device.split("#");
// //                   String name = parts[0];
// //                   String mac = parts[1];
// //
// //                   return ListTile(
// //                     title: Text(name),
// //                     subtitle: Text(mac),
// //                     trailing: const Icon(Icons.bluetooth),
// //                     onTap: () => connectToPrinter(mac),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
