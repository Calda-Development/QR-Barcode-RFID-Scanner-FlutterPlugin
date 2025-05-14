import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerWidget extends StatefulWidget {
  const MobileScannerWidget({super.key});

  @override
  State<MobileScannerWidget> createState() => _MobileScannerWidgetState();
}

class _MobileScannerWidgetState extends State<MobileScannerWidget> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void initState() {
    // unawaited(_controller.start());
    print('MobileScannerWidget initState');

    _controller.barcodes.forEach((BarcodeCapture element) {
      print('Barcode stream event');
      element.barcodes.forEach((Barcode element) {
        print('Barcode: ${element.displayValue}');
      });
    });

    super.initState();
  }

  @override
  Future<void> dispose() async {
    // await _controller.dispose();
    super.dispose();
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
          controller: _controller,
          fit: BoxFit.cover,
          scanWindow: scanWindow,
          errorBuilder: (context, error) {
            return ScannerErrorWidget(error: error);
          },
        ),
        StreamBuilder(
          stream: _controller.barcodes,
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
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: Padding(
        //     padding: const EdgeInsets.all(32.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [ToggleFlashlightButton(controller: _controller)],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 8.0,
    required this.borderColor,
  });

  final Rect scanWindow;
  final double borderRadius;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    // we need to pass the size to the custom paint widget
    final backgroundPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath =
        Path()..addRRect(
          RRect.fromRectAndCorners(
            scanWindow,
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
            bottomLeft: Radius.circular(borderRadius),
            bottomRight: Radius.circular(borderRadius),
          ),
        );

    final backgroundPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.7)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.dstOver;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(errorMessage, style: const TextStyle(color: Colors.white)),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              icon: Image.asset('assets/images/flash_on.png'),
              iconSize: 56,
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              icon: Image.asset('assets/images/flash_off.png'),
              iconSize: 56,
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              icon: Image.asset('assets/images/flash_on.png'),
              iconSize: 56,
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
