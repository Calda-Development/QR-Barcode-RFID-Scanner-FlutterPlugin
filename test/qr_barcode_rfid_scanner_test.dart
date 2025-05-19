import 'package:flutter_test/flutter_test.dart';
import 'package:qr_barcode_rfid_scanner/qr_barcode_rfid_scanner.dart';
import 'package:qr_barcode_rfid_scanner/qr_barcode_rfid_scanner_platform_interface.dart';
import 'package:qr_barcode_rfid_scanner/qr_barcode_rfid_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQrBarcodeRfidScannerPlatform
    with MockPlatformInterfaceMixin
    implements QrBarcodeRfidScannerPlatform {}

void main() {
  final QrBarcodeRfidScannerPlatform initialPlatform =
      QrBarcodeRfidScannerPlatform.instance;

  test('$MethodChannelQrBarcodeRfidScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQrBarcodeRfidScanner>());
  });
}
