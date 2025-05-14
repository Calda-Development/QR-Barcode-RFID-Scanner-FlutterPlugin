import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qr_barcode_rfid_scanner_platform_interface.dart';

/// An implementation of [QrBarcodeRfidScannerPlatform] that uses method channels.
class MethodChannelQrBarcodeRfidScanner extends QrBarcodeRfidScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qr_barcode_rfid_scanner');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
