import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants.dart';
import '../../db/database_helper.dart';
import '../../models/booking.dart';
import 'qr_valid_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final TextEditingController _manualIdController = TextEditingController();
  bool scanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ==== TOP BAR ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: const [
                  Icon(Icons.menu, size: 28),
                  Spacer(),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage("assets/images/security_profile.jpg"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Scan QR Code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Align the QR code within the frame to scan.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // ==== SCAN BOX ====
            Expanded(
              child: Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimaryGreen, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (capture) async {
                        if (scanning) return;
                        scanning = true;

                        final code = capture.barcodes.first.rawValue ?? "";
                        _openValidation(code);
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==== INPUT MANUAL ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _manualIdController,
                  decoration: const InputDecoration(
                    hintText: "Or enter the ‘Unique Id’ below.",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==== BUTTON VALIDATE ====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_manualIdController.text.isNotEmpty) {
                      _openValidation(_manualIdController.text.trim());
                    }
                  },
                  child: const Text(
                    "Validate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _openValidation(String code) async {
    Booking? booking =
        await DatabaseHelper.instance.getBookingByUniqueId(code);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QrValidScreen(
          booking: booking,
          scannedCode: code,
        ),
      ),
    );
  }
}
