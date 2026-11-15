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

    // Tap Members & ID tab
    await tester.tap(find.text('Members & ID'));
    await tester.pumpAndSettle();

    expect(find.text('Membership & Family ID'), findsOneWidget);
    expect(find.text('PASTORAL APPROVED MEMBER'), findsOneWidget);
    expect(find.text('AOE-FAM-2026-002'), findsWidgets);
    expect(find.text('AOE-FAM-2026-002-H1'), findsOneWidget);

    // Switch to Pastoral Admin view (Larry & Soma)
    await tester.tap(find.textContaining('Pastoral Admin'));
    await tester.pumpAndSettle();

    expect(find.text('Pastoral Approval Desk — Alpha Omega Ekklesia'), findsOneWidget);
    expect(find.text("The D'Cruz Family"), findsOneWidget);

    // Approve a pending family and verify unique Family ID AOE-FAM-2026-003 is issued
    final approveBtn = find.text('Approve & Issue Family ID (AOE-FAM-2026-003)').first;
    await tester.ensureVisible(approveBtn);
    await tester.tap(approveBtn);
    await tester.pumpAndSettle();

    expect(find.textContaining('Issued ID: AOE-FAM-2026-003'), findsOneWidget);

    // Tap Groups tab (7 Fellowship Groups)
    await tester.tap(find.text('Groups'));
    await tester.pumpAndSettle();

    expect(find.text('Fellowship Groups (7)'), findsOneWidget);
    expect(find.text('Pastors Larry & Soma Augustus (Super Bosses)'), findsOneWidget);
    expect(find.text('1. Sunday School'), findsOneWidget);
    expect(find.text("2. Men's Fellowship"), findsOneWidget);
    expect(find.text("3. Women's Fellowship"), findsOneWidget);

    // Switch to Group Approvals (Admin & Super Boss Desk)
    await tester.tap(find.textContaining('Group Approvals'));
    await tester.pumpAndSettle();

    expect(find.text('Fellowship Group Approval Authority'), findsOneWidget);
    expect(find.text('Super Boss Roster: Group Admins (7 Groups)'), findsOneWidget);

    // Approve a pending member join request into Sunday School
    final groupApproveBtn = find.text('Approve into 1. Sunday School');
    await tester.ensureVisible(groupApproveBtn);
    await tester.tap(groupApproveBtn);
    await tester.pumpAndSettle();

    expect(find.textContaining('into 1. Sunday School by Super Boss: Pastor Larry Joshua Augustus'), findsOneWidget);

    // Switch back to All 7 Groups and open Sunday School Group Chat
    await tester.ensureVisible(find.text('All 7 Groups'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All 7 Groups'));
    await tester.pumpAndSettle();

    final openChatBtn = find.text('Open Group Chat (Emojis & Links)').first;
    await tester.ensureVisible(openChatBtn);
    await tester.tap(openChatBtn);
    await tester.pumpAndSettle();

    // Verify WhatsApp-style Group Chat screen with Super Boss & Group Admin messages, Emojis, and Shared Links
    expect(find.text('SUPER BOSS · PASTOR'), findsWidgets);
    expect(find.text('GROUP ADMIN'), findsOneWidget);
    expect(find.textContaining('Alpha Omega Ekklesia — Sunday Worship Livestream'), findsOneWidget);

    // Open Emoji Picker Tray and send a message with emoji & link
    await tester.tap(find.byIcon(Icons.emoji_emotions_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).last,
      'Praise the Lord! Joining via https://aoekklesia.org/live',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.textContaining('Praise the Lord! Joining via https://aoekklesia.org/live'), findsOneWidget);

    // Pop back from Group Chat and navigate to Home -> Celebrations (Birthdays, Anniversaries & Baptisms)
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Birthdays, Anniversaries & Baptisms'), findsOneWidget);
    await tester.tap(find.text('Celebrations (3)'));
    await tester.pumpAndSettle();

    // Verify Birthday, Anniversary, and Baptism reminders are displayed
    expect(find.text('BIRTHDAY REMINDER'), findsWidgets);
    expect(find.text('ANNIVERSARY REMINDER'), findsOneWidget);
    expect(find.text('BAPTISM REMINDER'), findsWidgets);
    expect(find.text('Aaron Fernandez'), findsOneWidget);
    expect(find.text('Desmond & Lorraine Fernandez'), findsOneWidget);
    expect(find.text("Winfred D'Cruz"), findsWidgets);

    // Send a quick wish on Aaron's Birthday
    final wishChip = find.text('Happy Birthday! God Bless You!').first;
    await tester.ensureVisible(wishChip);
    await tester.tap(wishChip);
    await tester.pumpAndSettle();

    expect(find.text('19 Wishes'), findsOneWidget);
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
