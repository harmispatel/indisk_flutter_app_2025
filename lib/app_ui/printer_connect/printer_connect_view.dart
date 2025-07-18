import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPrinterPage extends StatefulWidget {
  const BluetoothPrinterPage({super.key});

  @override
  State<BluetoothPrinterPage> createState() => _BluetoothPrinterPageState();
}

class _BluetoothPrinterPageState extends State<BluetoothPrinterPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection? connection;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _selectedDevice;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    initBluetooth();
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

  void initBluetooth() async {
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    FlutterBluetoothSerial.instance.onStateChanged().listen((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      _devicesList = devices;
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection newConnection =
          await BluetoothConnection.toAddress(device.address);
      connection = newConnection;
      setState(() {
        _selectedDevice = device;
        _isConnected = true;
      });
      print("Connected to device");
    } catch (e) {
      print("Connection error: $e");
    }
  }

  void printSample() async {
    if (connection == null || !_isConnected) return;
    String text =
        "\nThe Food Place\nBurger x2       \$10.00\nFries x1        \$3.50\n--------------------------\nTotal:          \$13.50\n\nThank you!\n\n\n";
    Uint8List bytes = Uint8List.fromList(utf8.encode(text));
    connection!.output.add(bytes);
    await connection!.output.allSent;
    print("Printed successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Printer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bluetooth: ${_bluetoothState.toString().split('.')[1]}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                List<BluetoothDevice> devices =
                    await FlutterBluetoothSerial.instance.getBondedDevices();
                setState(() {
                  _devicesList = devices;
                });
              },
              child: const Text("Refresh Devices"),
            ),
            const SizedBox(height: 20),
            const Text("Select Device:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _devicesList.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = _devicesList[index];
                  return ListTile(
                    title: Text(device.name ?? "Unknown"),
                    subtitle: Text(device.address),
                    trailing: ElevatedButton(
                      onPressed: () => connectToDevice(device),
                      child: const Text("Connect"),
                    ),
                  );
                },
              ),
            ),
            if (_isConnected)
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text("Print Sample Receipt"),
                  onPressed: printSample,
                ),
              )
          ],
        ),
      ),
    );
  }
}
