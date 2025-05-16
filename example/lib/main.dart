import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_barcode_rfid_scanner/datawedge/zebra_datawedge.dart';
import 'package:qr_barcode_rfid_scanner/qr_barcode_rfid_scanner.dart';
import 'package:qr_barcode_rfid_scanner_example/mobile_camera_scanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _qrBarcodeRfidScannerPlugin = QrBarcodeRfidScanner();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _qrBarcodeRfidScannerPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome(_qrBarcodeRfidScannerPlugin));
  }
}

class MyHome extends StatelessWidget {
  final QrBarcodeRfidScanner qrBarcodeRfidScannerPlugin;

  const MyHome(this.qrBarcodeRfidScannerPlugin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child: ListView(
          children: [
            _buildItem(
              context: context,
              label: 'Mobile Camera Scanner',
              page: const BarcodeCameraScannerPage(),
            ),
            _buildItem(
                context: context,
                label: 'Init Scanner',
                onPressed: () {
                  qrBarcodeRfidScannerPlugin.init();
                }),
            _buildItem(
                context: context,
                label: 'Barcode Scanner',
                onPressed: () {
                  qrBarcodeRfidScannerPlugin.startBarcodeScan(
                      onScanResult: (result) {
                        print('Barcode onScanResult: $result');
                      },
                      stopListeningAfterScanResult: true);
                }),
            _buildItem(
                context: context,
                label: 'Single RFID Scanner',
                onPressed: () {
                  qrBarcodeRfidScannerPlugin.startSingleRFIDScan(
                    onScanResult: (data, error) {
                      print(
                          'RFID onScanResult: $data, error: ${error?.message} #${error?.numberOfTags}');
                    },
                  );
                }),
            _buildItem(
                context: context,
                label: 'Inventory RFID Scanner',
                onPressed: () {
                  qrBarcodeRfidScannerPlugin.setInventoryStreamMode(
                    onScanResult: (List<String> data) {
                      data
                          .asMap()
                          .map((index, value) =>
                              MapEntry(index, '#$index: $value'))
                          .values
                          .forEach(
                        (element) {
                          print('RFID Inventory: $element');
                        },
                      );
                    },
                  );
                }),
          ],
        ),
      ), //Stack(children: [MobileCameraScannerWidget()])
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String label,
    Widget? page,
    Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed ??
              () {
                if (page != null) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => page));
                }
              },
          child: Text(label),
        ),
      ),
    );
  }
}
