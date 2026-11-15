import 'package:flutter/material.dart';
import 'package:church_digital_platform_mobile/church_core.dart';

/// Configuration definition for Alpha Omega Ekklesia (Chennai, India).
abstract final class AlphaOmegaEkklesiaConfig {
  static const theme = ChurchThemeConfig(
    id: 'alpha-omega-ekklesia',
    displayName: 'Alpha Omega Ekklesia',
    primary: Color(0xFF18284A), // Deep Midnight Navy from cross & omega
    primaryContainer: Color(0xFF233761), // Nave Navy Container
    onPrimary: Colors.white,
    onPrimaryContainer: Color(0xFFFEF08A), // Warm Gold foreground
    secondary: Color(0xFFBA9A45), // Celestial Gold from the flame
    secondaryContainer: Color(0xFFFBF4DC), // Soft Gold Tint
    accentGold: Color(0xFFD4B258), // Radiant Gold highlight
    accentSuccess: Color(0xFF10B981),
    scaffoldBackground: Color(0xFFF8FAFC), // Crisp Alabaster
    cardBackground: Colors.white,
    containerBackground: Color(0xFFF1F5F9), // Slate soft container
    containerLow: Color(0xFFF8FAFC),
    hairlineBorder: Color(0xFFE2E8F0), // Subtle hairline
    ink: Color(0xFF0F172A),
    inkMuted: Color(0xFF475569),
    fontFamily: null, // Dignified modern sans
    cardRadius: 16.0,
  );

  static final profile = ChurchProfileConfig(
    churchId: 'alpha-omega-ekklesia',
    churchName: 'Alpha Omega Ekklesia',
    subtitle: 'Chennai, India · Pastors Larry & Soma Augustus',
    address: 'Chennai, Tamil Nadu, India',
    theme: theme,
    terminology: const ChurchTerminology(
      serviceName: 'Sunday Worship Service',
      clergyTitle: 'Pastor',
      worshipLabel: 'Praise & Worship Hymns',
      prayerLabel: 'Intercessory Prayer Requests',
      fellowshipLabel: 'Fellowship & Ministries',
      givingLabel: 'Tithes & Offerings (UPI)',
    ),
    upi: const ChurchUpiConfig(
      vpa: 'larryjoshuaa@oksbi',
      merchantName: 'Alpha Omega Ekklesia',
      quickPresets: [200, 500, 1000, 2000, 5000],
      availableFunds: [
        'Sunday Tithes & General Ministry',
        'Church Building & Facility Fund',
        'Benevolence & Welfare Fund',
        'Missions & Outreach',
      ],
    ),
  );
}
