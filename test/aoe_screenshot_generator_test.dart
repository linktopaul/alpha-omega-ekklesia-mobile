import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_omega_ekklesia_mobile/main.dart';

const String outDir = r'C:\Users\linkt\.gemini\antigravity\brain\29b7c671-ad3c-454f-bb0a-b365177c66a2\demo_slides_aoe';

Future<void> _loadFonts() async {
  final fontMap = <String, List<String>>{
    'Roboto': [
      r'C:\Windows\Fonts\segoeui.ttf',
      r'C:\Windows\Fonts\segoeuib.ttf',
      r'C:\Windows\Fonts\segoeuii.ttf',
      r'C:\Windows\Fonts\segoeuiz.ttf',
      r'C:\Windows\Fonts\seguisb.ttf',
    ],
    'Segoe UI': [
      r'C:\Windows\Fonts\segoeui.ttf',
      r'C:\Windows\Fonts\segoeuib.ttf',
      r'C:\Windows\Fonts\segoeuii.ttf',
      r'C:\Windows\Fonts\seguisb.ttf',
    ],
    'MaterialIcons': [
      r'C:\Users\linkt\dev\flutter\bin\cache\artifacts\material_fonts\MaterialIcons-Regular.otf',
    ],
  };

  for (final entry in fontMap.entries) {
    final loader = FontLoader(entry.key);
    var loadedAny = false;
    for (final path in entry.value) {
      final file = File(path);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
        loadedAny = true;
      }
    }
    if (loadedAny) {
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

    // 5. Member View: Digital Family Membership ID Card
    await tester.tap(find.text('Members & ID'));
    await tester.pumpAndSettle();
    await _captureScreen(tester, repaintKey, '05_aoe_member_family_id_card.png');

    // 6. Pastoral Admin View: Pastors Larry & Soma Approval Queue
    await tester.tap(find.textContaining('Pastoral Admin'));
    await tester.pumpAndSettle();
    await _captureScreen(tester, repaintKey, '06_aoe_pastoral_approval_queue.png');
  });
}
