import 'package:flutter/material.dart';
import '../constants.dart';
import '../db/database_helper.dart';
import '../models/booking.dart';
import '../routes/custom_routes.dart';
import '../screens/login_screen.dart';

import 'incoming_riders_screen.dart';
import 'scan_qr_screen.dart';
import 'security_history_screen.dart';

class SecurityHomeScreen extends StatelessWidget {
  const SecurityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// FLOATING SCAN BUTTON
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: kPrimaryGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.15),
            )
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.qr_code_scanner,
              size: 34, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScanQrScreen()),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/logo3.png",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  /// LOGOUT
                  Positioned(
                    right: 15,
                    top: 15,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          fadeRoute(const LoginScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "UPN ‘Veteran’ Yogyakarta Security",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

            /// PROFILE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/logo2.png"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Amanda Neyla",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Security Guard", style: TextStyle(fontSize: 13)),
                      Text("Badge number - SG911",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MENU GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _menuCard(
                        context,
                        title: "Notifications",
                        icon: Icons.notifications,
                        badge: true,
                        onTap: () => _showNotifications(context),
                      ),
                      const SizedBox(width: 12),
                      _menuCard(
                        context,
                        title: "View Incoming Rides",
                        icon: Icons.people_alt_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const IncomingRidesScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _menuCard(
                        context,
                        title: "Parking History",
                        icon: Icons.history,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const SecurityHistoryScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _menuCard(
                        context,
                        title: "Contact Police",
                        icon: Icons.local_police,
                        onTap: () => _showPoliceContact(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// MENU CARD
  /// =========================
  Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool badge = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.05),
              )
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 30, color: kPrimaryGreen),
                    const SizedBox(height: 6),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              if (badge)
                Positioned(
                  right: 12,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// NOTIFICATIONS DIALOG
  /// =========================
  void _showNotifications(BuildContext context) async {
  final List<Booking> activeBookings =
      await DatabaseHelper.instance.getActiveBookings();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Latest Notifications"),
      content: SizedBox(
        width: double.maxFinite,
        child: activeBookings.isEmpty
            ? const Text(
                "No new incoming vehicles at the moment.",
                style: TextStyle(color: Colors.grey),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: activeBookings.length,
                itemBuilder: (context, index) {
                  final b = activeBookings[index];

                  return ListTile(
                    leading: const Icon(
                      Icons.directions_car,
                      color: kPrimaryGreen,
                    ),
                    title: Text(
                      "Vehicle Arrived - ${b.plateNumber}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Area: ${b.areaName} • Slot: ${b.slot}\nCheck-in: ${b.startTime}",
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    ),
  );
}


  /// =========================
  /// POLICE CONTACT DIALOG
  /// =========================
  void _showPoliceContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Emergency Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Police Hotline: 110"),
            SizedBox(height: 8),
            Text("Campus Security Office"),
            Text("Phone: (0274) 486737"),
            SizedBox(height: 8),
            Text(
              "Use this contact in case of emergency situations or security threats.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}
