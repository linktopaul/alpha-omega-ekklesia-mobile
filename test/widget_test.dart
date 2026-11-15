import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_omega_ekklesia_mobile/main.dart';
import 'package:alpha_omega_ekklesia_mobile/config/church_config.dart';

void main() {
  testWidgets('AlphaOmegaEkklesiaApp boots and renders church identity & pastors', (WidgetTester tester) async {
    await tester.pumpWidget(const AlphaOmegaEkklesiaApp());
    await tester.pumpAndSettle();

    // Verify church branding & title
    expect(find.text('Alpha Omega Ekklesia'), findsWidgets);
    expect(find.text('Chennai, India · Anglo-Indian Church'), findsOneWidget);

    // Verify scripture & pastoral leadership
    expect(find.text('Revelation 22:13'), findsOneWidget);
    expect(
      find.text('Pastors: Larry Joshua Augustus & Soma Augustus'),
      findsOneWidget,
    );

    // Verify weekly gatherings
    expect(find.text('Weekly Gatherings & Services'), findsOneWidget);
    expect(find.text('Sunday Worship Service & Holy Communion'), findsOneWidget);

    // Verify UPI VPA is displayed on home screen
    expect(find.text('VPA: larryjoshuaa@oksbi'), findsOneWidget);
  });

  testWidgets('Navigation bar switches to Give (UPI), Prayer, and Worship tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const AlphaOmegaEkklesiaApp());
    await tester.pumpAndSettle();

    // Tap Give tab
    await tester.tap(find.text('Give (UPI)'));
    await tester.pumpAndSettle();

    expect(find.text('Tithes & Digital Giving'), findsOneWidget);
    expect(find.text('larryjoshuaa@oksbi'), findsOneWidget);
    expect(find.text('Sunday Tithes & General Ministry'), findsOneWidget);
    expect(find.text('₹2000'), findsOneWidget);

    // Tap ₹2000 preset
    await tester.ensureVisible(find.text('₹2000'));
    await tester.tap(find.text('₹2000'));
    await tester.pumpAndSettle();
    expect(find.text('2000'), findsOneWidget);

    // Tap Prayer Wall tab
    await tester.tap(find.text('Prayer Wall'));
    await tester.pumpAndSettle();

    expect(find.text('Intercessory Prayer Wall'), findsOneWidget);
    expect(find.text('Request Prayer'), findsOneWidget);
    expect(find.text('Active Prayer Petitions'), findsOneWidget);

    // Tap Worship tab
    await tester.tap(find.text('Worship'));
    await tester.pumpAndSettle();

    expect(find.text('Hymns & Worship Setlists'), findsOneWidget);
    expect(find.text('Great Is Thy Faithfulness'), findsOneWidget);
    expect(find.textContaining('Classic Anglo-Indian Hymn'), findsOneWidget);
  });

  test('AlphaOmegaEkklesiaConfig verifies proper theme tokens and UPI vpa', () {
    final profile = AlphaOmegaEkklesiaConfig.profile;
    expect(profile.churchId, 'alpha-omega-ekklesia');
    expect(profile.upi.vpa, 'larryjoshuaa@oksbi');
    expect(profile.upi.merchantName, 'Alpha Omega Ekklesia');
    expect(profile.terminology.clergyTitle, 'Pastor');

    final theme = AlphaOmegaEkklesiaConfig.theme;
    expect(theme.primary, const Color(0xFF18284A));
    expect(theme.secondary, const Color(0xFFBA9A45));
    expect(theme.onPrimary, Colors.white);
  });
}
