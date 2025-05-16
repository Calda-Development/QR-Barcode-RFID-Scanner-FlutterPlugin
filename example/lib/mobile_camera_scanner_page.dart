import 'package:flutter/material.dart';
import 'package:qr_barcode_rfid_scanner/mobile_camera_scanner/mobile_camera_scanner_widget.dart';

class BarcodeCameraScannerPage extends StatefulWidget {
  const BarcodeCameraScannerPage({super.key});

  @override
  State<BarcodeCameraScannerPage> createState() =>
      _BarcodeCameraScannerPageState();
}

class _BarcodeCameraScannerPageState extends State<BarcodeCameraScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Camera Scanner')),
      backgroundColor: Colors.black,
      body: Stack(children: [
        MobileCameraScannerWidget(onBarcode: (String barcode) {
          print('BarcodeCameraScannerPage: $barcode');
        })
      ]),
    );
  }
}
