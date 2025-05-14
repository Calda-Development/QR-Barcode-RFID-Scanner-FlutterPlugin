
import 'qr_barcode_rfid_scanner_platform_interface.dart';

class QrBarcodeRfidScanner {
  Future<String?> getPlatformVersion() {
    return QrBarcodeRfidScannerPlatform.instance.getPlatformVersion();
  }
}
