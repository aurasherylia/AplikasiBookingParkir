import 'package:flutter/material.dart';

import '../constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScreenPadding),
        child: Column(
          children: const [
            Row(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                ),
                SizedBox(width: 16),
                _SettingsTile(icon: Icons.person_outline, label: 'Account'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _SettingsTile(icon: Icons.help_outline, label: 'Terms of Use'),
                SizedBox(width: 16),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  label: 'Privacy Policy',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingsTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 22,
              backgroundColor: kPrimaryGreen.withOpacity(0.2),
              child: Icon(icon, color: kPrimaryGreen),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
