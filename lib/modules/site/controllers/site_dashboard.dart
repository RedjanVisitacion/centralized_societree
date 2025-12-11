import 'package:flutter/material.dart';
import 'site_controller.dart';
import '../dashboards/site_event.dart';
import '../dashboards/site_services.dart';
import '../dashboards/site_attendance.dart';

class SiteDashboard extends StatefulWidget {
  final String orgName;
  final String assetPath;

  const SiteDashboard({
    super.key,
    required this.orgName,
    required this.assetPath,
  });

  @override
  State<SiteDashboard> createState() => _SiteDashboardState();
}

class _SiteDashboardState extends State<SiteDashboard> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SiteHomeScreen(onNavigate: _navigateTo),
      const AttendanceScreen(),
      const EventsScreen(),
      _NotificationsScreen(),
      _MessagesScreen(),
      const ServicesScreen(),
      _ProfileScreen(),
      _BalanceInquiryScreen(),
    ];
  }

  void _navigateTo(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _screens[_selectedIndex]);
  }
}

// Placeholder screens for categories

class _NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

class _MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Messages Screen')),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class _BalanceInquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Inquiry'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Balance Inquiry Screen')),
    );
  }
}
