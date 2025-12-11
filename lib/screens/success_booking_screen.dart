import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/booking.dart';
import '../routes/custom_routes.dart';
import 'booking_details_screen.dart';

class SuccessBookingScreen extends StatefulWidget {
  final Booking booking;

  const SuccessBookingScreen({super.key, required this.booking});

  @override
  State<SuccessBookingScreen> createState() => _SuccessBookingScreenState();
}

class _SuccessBookingScreenState extends State<SuccessBookingScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  Future<void> _startDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _loading
                ? _loadingCard()
                : _successCard(context, widget.booking),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOADING CARD
  // ============================================================
  Widget _loadingCard() {
    return Container(
      key: const ValueKey("loading"),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, size: 80, color: kPrimaryGreen),
          SizedBox(height: 12),
          Text(
            "Space Successfully Booked",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text("Notifying Security Guards"),
          SizedBox(height: 18),
          CircularProgressIndicator(color: kPrimaryGreen),
        ],
      ),
    );
  }

  // ============================================================
  // SUCCESS CARD
  // ============================================================
  Widget _successCard(BuildContext context, Booking booking) {
    return Container(
      key: const ValueKey("success"),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.07),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 80, color: kPrimaryGreen),
          const SizedBox(height: 12),

          const Text(
            "Space Successfully Booked",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 14),

          // PLATE NUMBER DISPLAY
          Text(
            "Plate Number: ${booking.plateNumber}",
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: 250,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  fadeRoute(
                    BookingDetailsScreen(booking: booking),
                  ),
                );
              },
              child: const Text(
                "View Booking Details",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
