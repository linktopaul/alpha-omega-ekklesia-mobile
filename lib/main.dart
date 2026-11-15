import 'package:flutter/material.dart';
import 'package:church_digital_platform_mobile/church_core.dart';
import 'config/church_config.dart';
import 'screens/aoe_home_screen.dart';
import 'screens/aoe_giving_screen.dart';
import 'screens/aoe_prayer_screen.dart';
import 'screens/aoe_worship_screen.dart';
import 'screens/aoe_membership_screen.dart';
import 'screens/aoe_fellowship_groups_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AlphaOmegaEkklesiaApp());
}

class AlphaOmegaEkklesiaApp extends StatelessWidget {
  const AlphaOmegaEkklesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AlphaOmegaEkklesiaConfig.profile.churchName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromConfig(AlphaOmegaEkklesiaConfig.theme),
      home: const AoeMainNavigation(),
    );
  }
}

class AoeMainNavigation extends StatefulWidget {
  const AoeMainNavigation({super.key});

  @override
  State<AoeMainNavigation> createState() => _AoeMainNavigationState();
}

class _AoeMainNavigationState extends State<AoeMainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      AoeHomeScreen(
        onNavigateToGiving: () => setState(() => _currentIndex = 1),
        onNavigateToPrayer: () => setState(() => _currentIndex = 2),
        onNavigateToWorship: () => setState(() => _currentIndex = 3),
      ),
      const AoeGivingScreen(),
      const AoePrayerScreen(),
      const AoeWorshipScreen(),
      const AoeFellowshipGroupsScreen(),
      const AoeMembershipScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism),
            label: 'Give (UPI)',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Prayer Wall',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Worship',
          ),
          NavigationDestination(
            icon: Icon(Icons.diversity_3_outlined),
            selectedIcon: Icon(Icons.diversity_3),
            label: 'Groups',
          ),
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Members & ID',
          ),
        ],
      ),
    );
  }
}
