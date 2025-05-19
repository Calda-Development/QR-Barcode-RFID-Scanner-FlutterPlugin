import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

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
                  QrBarcodeRfidScanner().init();
                }),
            _buildItem(
                context: context,
                label: 'Disconnect Scanner',
                onPressed: () {
                  QrBarcodeRfidScanner().disconnect();
                }),
            _buildItem(
                context: context,
                label: 'Barcode Scanner',
                onPressed: () {
                  QrBarcodeRfidScanner().startBarcodeScan(
                      onScanResult: (result) {
                        print('Barcode onScanResult: $result');
                      },
                      stopListeningAfterScanResult: true);
                }),
            _buildItem(
                context: context,
                label: 'Single RFID Scanner',
                onPressed: () {
                  QrBarcodeRfidScanner().startSingleRFIDScan(
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
                QrBarcodeRfidScanner().setInventoryStreamMode(
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
              },
            ),
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
