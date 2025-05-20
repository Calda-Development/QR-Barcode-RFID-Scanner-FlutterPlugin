import 'package:qr_barcode_rfid_scanner/brady/brady.dart';
import 'package:qr_barcode_rfid_scanner/datawedge/zebra_datawedge.dart';

class BarcodeSingleton {
  static final BarcodeSingleton _instance = BarcodeSingleton._internal();

  factory BarcodeSingleton() {
    return _instance;
  }

  BarcodeSingleton._internal();

  void startBarcodeScan({
    required Null Function(String result) onScanResult,
    required bool stopListeningAfterScanResult,
  }) {
    ZebraDatawedge().startBarcodeScan(
      onScanResult: onScanResult,
      stopListeningAfterScanResult: stopListeningAfterScanResult,
    );

    Brady().startBarcodeScan(
      onScanResult: onScanResult,
      stopListeningAfterScanResult: stopListeningAfterScanResult,
    );
  }
}
