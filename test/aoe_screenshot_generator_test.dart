import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_omega_ekklesia_mobile/main.dart';

const String outDir = r'C:\Users\linkt\.gemini\antigravity\brain\20fabf14-68ca-4c2a-b25d-f1d6800c9a11\demo_slides_aoe';

Future<void> _loadFonts() async {
  final fontFiles = {
    'Segoe UI': r'C:\Windows\Fonts\segoeui.ttf',
    'Roboto': r'C:\Windows\Fonts\arial.ttf',
  };
  for (final entry in fontFiles.entries) {
    final file = File(entry.value);
    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      final loader = FontLoader(entry.key);
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
    }
  }
}

Future<void> _captureScreen(
  WidgetTester tester,
  GlobalKey key,
  String fileName,
) async {
  await tester.binding.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    final file = File('$outDir\\$fileName');
    file.writeAsBytesSync(pngBytes);
  });
}

void main() {
  testWidgets('Generate high-resolution Alpha Omega Ekklesia screenshots', (WidgetTester tester) async {
    await _loadFonts();

    tester.view.physicalSize = const Size(820, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repaintKey = GlobalKey();

    await tester.pumpWidget(
      RepaintBoundary(
        key: repaintKey,
        child: const AlphaOmegaEkklesiaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Home Feed
    await _captureScreen(tester, repaintKey, '01_aoe_home_feed.png');

    // 2. UPI Giving
    await tester.tap(find.text('Give (UPI)'));
    await tester.pumpAndSettle();
    await _captureScreen(tester, repaintKey, '02_aoe_upi_giving.png');

    // 3. Intercessory Prayer Wall
    await tester.tap(find.text('Prayer Wall'));
    await tester.pumpAndSettle();
    await _captureScreen(tester, repaintKey, '03_aoe_prayer_wall.png');

    // 4. Hymns & Worship Setlists
    await tester.tap(find.text('Worship'));
    await tester.pumpAndSettle();
    await _captureScreen(tester, repaintKey, '04_aoe_worship_setlists.png');
  });
}
