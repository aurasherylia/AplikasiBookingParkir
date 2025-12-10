import 'package:flutter/material.dart';
import '../routes/custom_routes.dart';
import '../screens/booking_history_screen.dart';
import '../screens/how_it_works_screen.dart';
import '../screens/support_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage('assets/images/logo2.png'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aura Sherylia',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _drawerItem(
              icon: Icons.history,
              text: 'Parking History',
              onTap: () {
                Navigator.of(context).push(
                  slideRoute(const ParkingHistoryScreen()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.info_outline,
              text: 'How it works',
              onTap: () {
                Navigator.of(context).push(
                  slideRoute(const HowItWorksScreen()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.support_agent_outlined,
              text: 'Support',
              onTap: () {
                Navigator.of(context).push(
                  slideRoute(const SupportScreen()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                Navigator.of(context).push(
                  slideRoute(const SettingsScreen()),
                );
              },
            ),
            _drawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  fadeRoute(const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _drawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
