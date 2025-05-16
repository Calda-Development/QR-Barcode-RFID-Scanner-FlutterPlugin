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
    await ZebraDatawedge().init();
    await Brady().init();
  }

  void startBarcodeScan({
    required Null Function(dynamic result) onScanResult,
    required bool stopListeningAfterScanResult,
  }) {
    BarcodeSingleton().startBarcodeScan(
      onScanResult: onScanResult,
      stopListeningAfterScanResult: stopListeningAfterScanResult,
    );
  }

  void startSingleRFIDScan({
    required Null Function(String data, RFIDScanError? error) onScanResult,
  }) {
    RfidSingleton().startSingleRFIDScan(
      onScanResult: onScanResult,
    );
  }

  void setInventoryStreamMode({
    required Null Function(List<String> data) onScanResult,
  }) {
    RfidSingleton().setInventoryStreamMode(
      onScanResult: onScanResult,
    );
  }
}
