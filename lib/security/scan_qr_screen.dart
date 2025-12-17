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

class _ScanQrScreenState extends State<ScanQrScreen>
    with WidgetsBindingObserver {
  late MobileScannerController controller;
  bool scanned = false;
  final TextEditingController manualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: const [BarcodeFormat.qrCode],
    );

    _startCamera();
  }

  Future<void> _startCamera() async {
    // FIX untuk iPhone kamera lama menyala
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      await controller.start();
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    manualController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.paused) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------------------------------------------------
            // TOP BAR
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: const [
                  Icon(Icons.menu, size: 28),
                  Spacer(),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        AssetImage("assets/images/security_profile.jpg"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Scan QR Code",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Align the QR code within the\nframe to scan.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // CAMERA + FRAME
            // ---------------------------------------------------------
            Expanded(
              child: Center(
                child: Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimaryGreen, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Stack(
                      children: [
                        // CAMERA PREVIEW
                        MobileScanner(
                          controller: controller,
                          fit: BoxFit.cover,
                          onDetect: (capture) async {
                            if (scanned) return;
                            scanned = true;

                            final code =
                                capture.barcodes.first.rawValue ?? "";
                            _openValidation(code);
                          },
                        ),

                        // ICON BEFORE SCAN
                        if (!scanned)
                          Center(
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 42,
                              color: kPrimaryGreen.withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ---------------------------------------------------------
            // INPUT MANUAL – FIXED & NO OVERFLOW
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Text(
                    "Or enter the ‘Unique ID’ below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: manualController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // VALIDATE BUTTON FIXED
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Validate",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    if (manualController.text.isNotEmpty) {
                      _openValidation(manualController.text.trim());
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // VALIDATOR
  // ==============================================================
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
