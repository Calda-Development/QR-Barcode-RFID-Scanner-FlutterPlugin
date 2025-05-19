import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qr_barcode_rfid_scanner_method_channel.dart';

abstract class QrBarcodeRfidScannerPlatform extends PlatformInterface {
  /// Constructs a QrBarcodeRfidScannerPlatform.
  QrBarcodeRfidScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static QrBarcodeRfidScannerPlatform _instance =
      MethodChannelQrBarcodeRfidScanner();

  /// The default instance of [QrBarcodeRfidScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelQrBarcodeRfidScanner].
  static QrBarcodeRfidScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QrBarcodeRfidScannerPlatform] when
  /// they register themselves.
  static set instance(QrBarcodeRfidScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
