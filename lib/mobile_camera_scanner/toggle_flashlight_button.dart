import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
            return SizedBox(
              width: 56,
              height: 56,
              child: IconButton(
                icon: Image.asset(
                    'packages/qr_barcode_rfid_scanner/assets/images/flash_on.png'),
                iconSize: 56,
                onPressed: () async {
                  await controller.toggleTorch();
                },
              ),
            );
          case TorchState.off:
            return SizedBox(
              width: 56,
              height: 56,
              child: IconButton(
                icon: Image.asset(
                    'packages/qr_barcode_rfid_scanner/assets/images/flash_off.png'),
                iconSize: 56,
                onPressed: () async {
                  await controller.toggleTorch();
                },
              ),
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
