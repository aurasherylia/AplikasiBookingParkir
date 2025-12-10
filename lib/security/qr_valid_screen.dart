import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../db/database_helper.dart';
import '../../models/booking.dart';

class QrValidScreen extends StatelessWidget {
  final Booking? booking;
  final String scannedCode;

  const QrValidScreen({
    super.key,
    required this.booking,
    required this.scannedCode,
  });

  @override
  Widget build(BuildContext context) {
    final valid = booking != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Scan QR Code"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26),
        child:
            Center(child: valid ? _valid(context) : _invalid()),
      ),
    );
  }

  Widget _valid(BuildContext context) {
    final b = booking!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle,
              color: kPrimaryGreen, size: 70),

          const SizedBox(height: 10),
          const Text("Valid ID",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 40,
            backgroundImage:
                AssetImage("assets/images/user_placeholder.jpg"),
          ),

          const SizedBox(height: 8),
          const Text("Aura Sherylia",
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
          Text("Unique ID: ${b.uniqueId}",
              style: const TextStyle(
                  color: kPrimaryGreen,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),

          const Text("Booking Details",
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          _detail("Check-in Time:", b.startTime),
          _detail("Check-out Time:", b.endTime),
          _detail("Specifications:", "None"),

          const SizedBox(height: 20),

          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                await DatabaseHelper.instance.finishBooking(b.id!);
                Navigator.pop(context);
              },
              child: const Text("Allow Access",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _invalid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.cancel, size: 80, color: Colors.red),
        SizedBox(height: 10),
        Text("QR TIDAK VALID",
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
