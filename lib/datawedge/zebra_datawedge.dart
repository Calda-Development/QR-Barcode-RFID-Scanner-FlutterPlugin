import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';

class ZebraDatawedge {
  static final ZebraDatawedge _instance = ZebraDatawedge._internal();

  final FlutterDataWedge dataWedge = FlutterDataWedge();
  StreamSubscription? _onScanSubscription;

  factory ZebraDatawedge() {
    return _instance;
  }

  ZebraDatawedge._internal();

  Function(String result)? onScanResult;
  bool? stopListeningAfterScanResult;

  Future<void> init() async {
    await dataWedge.initialize();
    await dataWedge.createDefaultProfile(profileName: "BTV - Input App");
  }

  Future<void> startBarcodeScan({
    Function(String result)? onScanResult,
    bool? stopListeningAfterScanResult,
  }) async {
    this.onScanResult = onScanResult;
    this.stopListeningAfterScanResult = stopListeningAfterScanResult;

    _onScanSubscription = dataWedge.onScanResult.listen(_onScanResultEvent);
  }

  void setOnScanResult({
    Function(String result)? onScanResult,
    bool? stopListeningAfterScanResult,
  }) {
    this.onScanResult = onScanResult;
    this.stopListeningAfterScanResult = stopListeningAfterScanResult;

    _onScanSubscription?.cancel();
    _onScanSubscription = dataWedge.onScanResult.listen(_onScanResultEvent);
  }

  void removeOnScanResult() {
    onScanResult = null;
    stopListeningAfterScanResult = null;
    _onScanSubscription?.cancel();
  }

  void _onScanResultEvent(ScanResult result) {
    debugPrint('ZebraDatawedge onScanResultEvent: ${result.data}');

    if (onScanResult != null) {
      onScanResult!(result.data);
      if (stopListeningAfterScanResult != null &&
          stopListeningAfterScanResult!) {
        onScanResult = null;
        _onScanSubscription?.cancel();
      }
    }
  }
}
