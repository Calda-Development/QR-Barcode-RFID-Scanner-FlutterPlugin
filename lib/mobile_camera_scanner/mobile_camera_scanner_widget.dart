import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_barcode_rfid_scanner/mobile_camera_scanner/scanner_error_widget.dart';
import 'package:qr_barcode_rfid_scanner/mobile_camera_scanner/scanner_overlay.dart';
import 'package:qr_barcode_rfid_scanner/mobile_camera_scanner/toggle_flashlight_button.dart';

class MobileCameraScannerWidget extends StatefulWidget {
  final Function(String barcode) onBarcode;

  const MobileCameraScannerWidget({super.key, required this.onBarcode});

  @override
  State<MobileCameraScannerWidget> createState() =>
      _MobileCameraScannerWidgetState();
}

class _MobileCameraScannerWidgetState extends State<MobileCameraScannerWidget>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  StreamSubscription<Object?>? _subscription;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      if (barcodes.barcodes.firstOrNull != null &&
          barcodes.barcodes.firstOrNull?.displayValue != null) {
        // setState(() {
        print('BarcodeCapture: ${barcodes.barcodes.firstOrNull?.displayValue}');

        widget.onBarcode(barcodes.barcodes.firstOrNull!.displayValue!);
        // _barcode = barcodes.barcodes.firstOrNull;
        // });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 260,
      height: 260,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
        ),
        MobileScanner(
          controller: controller,
          fit: BoxFit.cover,
          errorBuilder: (context, error, child) {
            return ScannerErrorWidget(error: error);
          },
        ),
        StreamBuilder(
          stream: controller.barcodes,
          builder: (context, snapshot) {
            if (snapshot.data?.barcodes.lastOrNull?.displayValue != null) {
              return CustomPaint(
                painter: ScannerOverlay(
                  scanWindow: scanWindow,
                  borderColor: Colors.green,
                ),
              );
            } else {
              return CustomPaint(
                painter: ScannerOverlay(
                  scanWindow: scanWindow,
                  borderColor: Colors.white,
                ),
              );
            }
          },
        ),
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: FlutterFlowIconButton(
        //       borderRadius: 800.0,
        //       buttonSize: 40.0,
        //       fillColor: Colors.white,
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: FlutterFlowTheme.of(context).black,
        //         size: 24.0,
        //       ),
        //       onPressed: () async {
        //         context.safePop();
        //       },
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 115),
        //     child: Text(
        //       title,
        //       style: FlutterFlowTheme.of(context).titleLarge.override(
        //         fontFamily: 'Outfit',
        //         letterSpacing: 0.0,
        //         fontWeight: FontWeight.w700,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleFlashlightButton(controller: controller),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
