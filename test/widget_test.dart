// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:test_qrcode/qr_view.dart';

// Define a mock QRViewController

class MockQRViewController implements QRViewController {
  final StreamController<Barcode> _scanController = StreamController<Barcode>.broadcast();

  @override
  Stream<Barcode> get scannedDataStream => _scanController.stream;

  @override
  void dispose() {
    _scanController.close();
  }

  void simulateScan(String data) {
    final qrData = Barcode(data, BarcodeFormat.qrcode, null);
    _scanController.add(qrData);
  }

  @override
  Future<CameraFacing> flipCamera() async {
    return CameraFacing.back;
  }

  @override
  Future<CameraFacing> getCameraInfo() async {
    return CameraFacing.back;
  }

  @override
  Future<bool?> getFlashStatus() async {
    return true;
  }

  @override
  Future<SystemFeatures> getSystemFeatures() async {
    return SystemFeatures(true, true, true);
  }

  @override
  bool get hasPermissions => true;

  @override
  Future<void> pauseCamera() async {}

  @override
  Future<void> resumeCamera() async {}

  @override
  Future<void> scanInvert(bool isScanInvert) async {}

  @override
  Future<void> stopCamera() async {}

  @override
  Future<void> toggleFlash() async {}
}

void main() {
  const mockData = 'marcus';
  // Build our app and trigger a frame.
  testWidgets('QR Scanner Widget Test', (WidgetTester tester) async {
    // Create a mock QRViewController
    await tester.pumpWidget(const MaterialApp(
      home: QRViewExample(),
    ));

    expect(find.text('Scan a QR code'), findsOneWidget);
    final qrViewController = MockQRViewController();
    final qrViewFinder = find.byType(QRView);
    expect(qrViewFinder, findsOneWidget);
    final qrView = tester.widget<QRView>(qrViewFinder);
    qrView.onQRViewCreated(qrViewController);
    qrViewController.simulateScan(mockData);
    await tester.pump();
    expect(find.text('QR Code Value: $mockData'), findsOneWidget);
  });
}
