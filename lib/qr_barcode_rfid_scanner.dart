import 'package:flutter/cupertino.dart';
import 'package:nordicidnurplugin/nordicidnurplugin.dart';
import 'package:qr_barcode_rfid_scanner/rfid/rfid_singleton.dart';

import 'barcode/barcode_singleton.dart';
import 'brady/brady.dart';
import 'datawedge/zebra_datawedge.dart';
import 'qr_barcode_rfid_scanner_platform_interface.dart';

class QrBarcodeRfidScanner {
  Future<String?> getPlatformVersion() {
    return QrBarcodeRfidScannerPlatform.instance.getPlatformVersion();
  }

  Future<void> init() async {
    debugPrint('QrBarcodeRfidScanner init');
    await ZebraDatawedge().init();
    await Brady().init();
  }

  Future<void> disconnect() async {
    debugPrint('QrBarcodeRfidScanner disconnect');
    await ZebraDatawedge().disconnect();
    await Brady().disconnect();
  }

  void startBarcodeScan({
    required Null Function(dynamic result) onScanResult,
    required bool stopListeningAfterScanResult,
  }) {
    debugPrint('QrBarcodeRfidScanner startBarcodeScan');
    BarcodeSingleton().startBarcodeScan(
      onScanResult: onScanResult,
      stopListeningAfterScanResult: stopListeningAfterScanResult,
    );
  }

  void startSingleRFIDScan({
    required Null Function(String data, RFIDScanError? error) onScanResult,
  }) {
    debugPrint('QrBarcodeRfidScanner startSingleRFIDScan');
    RfidSingleton().startSingleRFIDScan(
      onScanResult: onScanResult,
    );
  }

  void setInventoryStreamMode({
    required Null Function(List<String> data) onScanResult,
  }) {
    debugPrint('QrBarcodeRfidScanner setInventoryStreamMode');
    RfidSingleton().setInventoryStreamMode(
      onScanResult: onScanResult,
    );
  }
}
