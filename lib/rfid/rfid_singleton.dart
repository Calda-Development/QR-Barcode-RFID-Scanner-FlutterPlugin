import 'package:nordicidnurplugin/nordicidnurplugin.dart';
import 'package:qr_barcode_rfid_scanner/brady/brady.dart';
import 'package:qr_barcode_rfid_scanner/datawedge/zebra_datawedge.dart';

class RfidSingleton {
  static final RfidSingleton _instance = RfidSingleton._internal();

  factory RfidSingleton() {
    return _instance;
  }

  RfidSingleton._internal();

  Future<void> init() async {
    await Brady().init();
  }

  void startSingleRFIDScan({
    required Null Function(String data, RFIDScanError? error) onScanResult,
  }) {
    Brady().scanSingleRFID(onScanResult: onScanResult);
  }

  void setInventoryStreamMode({
    required Null Function(List<String> data) onScanResult,
  }) {
    Brady().setInventoryStreamMode(onScanResult: onScanResult);
  }
}
