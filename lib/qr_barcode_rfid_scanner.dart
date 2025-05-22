import 'package:flutter/cupertino.dart';
import 'package:nordicidnurplugin/nordicidnurplugin.dart';
import 'package:qr_barcode_rfid_scanner/rfid/rfid_singleton.dart';

import 'barcode/barcode_singleton.dart';
import 'brady/brady.dart';
import 'datawedge/zebra_datawedge.dart';

class QrBarcodeRfidScanner {
  static final QrBarcodeRfidScanner _instance =
      QrBarcodeRfidScanner._internal();

  factory QrBarcodeRfidScanner() {
    return _instance;
  }

  QrBarcodeRfidScanner._internal();

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
    required Null Function(String result) onScanResult,
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

  Future<void> setOnSingleRfidScanStatusChange({
    Null Function(bool singleRFIDScanActive)? onSingleRfidScanStatusChange,
  }) async {
    RfidSingleton().setOnSingleRfidScanStatusChange(
      onSingleRfidScanStatusChange: onSingleRfidScanStatusChange,
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

  Future<void> setOnInventoryStreamScanStatusChange({
    required Null Function(bool inventoryStreamActive)?
        onInventoryStreamScanStatusChange,
  }) async {
    RfidSingleton().setOnInventoryStreamScanStatusChange(
      onInventoryStreamScanStatusChange: onInventoryStreamScanStatusChange,
    );
  }
}
