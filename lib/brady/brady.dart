import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:nordicidnurplugin/nordicidnurplugin.dart';

class Brady {
  static final Brady _instance = Brady._internal();

  factory Brady() {
    return _instance;
  }

  Brady._internal();

  NordicIDNurPlugin? _nordicIDNurPlugin;

  bool _isInitialised = false;
  bool _isConnected = false;
  bool _inventoryStreamActive = false;

  Function(String result)? _onBarcodeScanResult;
  Function(String data, RFIDScanError? error)? _onSingleRfidScanResult;
  Function(List<String> data)? _onInventoryStreamScanResult;

  Future<void> init() async {
    if (_isInitialised && _isConnected) {
      return;
    }

    _nordicIDNurPlugin = NordicIDNurPlugin(
      callback: NordicIDNurPluginCallback(
        onInitialised: (bool isInitialised) {
          _isInitialised = isInitialised;
        },
        onConnected: () {
          _isConnected = true;
        },
        onDisconnected: () {
          _isConnected = false;
        },
        onBarcodeScanned: (String data) {
          if (_onBarcodeScanResult != null) {
            _onBarcodeScanResult!(data);
          }
        },
        onSingleRFIDScanned: (String data, RFIDScanError? error) {
          if (_onSingleRfidScanResult != null) {
            _onSingleRfidScanResult!(data, error);
          }
        },
        onStartInventoryStream: () {
          _inventoryStreamActive = true;
        },
        onStopInventoryStream: () {
          _inventoryStreamActive = false;
        },
        onInventoryStreamEvent: (List<String> data) {
          if (_onInventoryStreamScanResult != null) {
            _onInventoryStreamScanResult!(data);
          }
        },
      ),
    );

    _nordicIDNurPlugin?.init(autoConnect: true);
  }

  Future<void> startBarcodeScan({
    required Null Function(String result) onScanResult,
    required bool stopListeningAfterScanResult,
  }) async {
    if (_nordicIDNurPlugin == null || _isInitialised == false) {
      debugPrint(
          'NordicIDNurPlugin not initializes! Have you forgot to call init()?');
      return;
    }
    if (_isConnected == false) {
      debugPrint('Scanner not connected!');
      return;
    }

    _onBarcodeScanResult = onScanResult;
    // stopListeningAfterScanResult already handled within scanBarcode

    _nordicIDNurPlugin?.scanBarcode(timeout: 5000);
  }

  Future<void> scanSingleRFID({
    required Null Function(String data, RFIDScanError? error) onScanResult,
  }) async {
    if (_nordicIDNurPlugin == null || _isInitialised == false) {
      debugPrint(
          'NordicIDNurPlugin not initializes! Have you forgot to call init()?');
      return;
    }
    if (_isConnected == false) {
      debugPrint('Scanner not connected!');
      return;
    }

    _onSingleRfidScanResult = onScanResult;

    _nordicIDNurPlugin?.scanSingleRFID(timeout: 5000);
  }

  Future<void> setInventoryStreamMode({
    required Null Function(List<String> data) onScanResult,
  }) async {
    if (_nordicIDNurPlugin == null || _isInitialised == false) {
      debugPrint(
          'NordicIDNurPlugin not initializes! Have you forgot to call init()?');
      return;
    }
    if (_isConnected == false) {
      debugPrint('Scanner not connected!');
      return;
    }

    _onInventoryStreamScanResult = onScanResult;

    _nordicIDNurPlugin?.setInventoryStreamMode();
  }

  Future<void> disconnect() async {
    _isInitialised = false;
    _isConnected = false;
    _inventoryStreamActive = false;

    await _nordicIDNurPlugin?.disconnect();
  }
}
