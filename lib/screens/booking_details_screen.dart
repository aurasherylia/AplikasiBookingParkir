import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants.dart';
import '../models/booking.dart';
import '../routes/custom_routes.dart';
import 'booking_history_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kScreenPadding,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// BACK BUTTON
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// ============== QR CODE CARD ==============
              _whiteCard(
                child: Column(
                  children: [
                    const Text(
                      "Slot Parkir UPN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // QR CODE
                    Container(
                      width: 180,
                      height: 180,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: QrImageView(
                        data: booking.uniqueId,
                        version: QrVersions.auto,
                        size: 160,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Unique ID: ${booking.uniqueId}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ============== BOOKING DETAILS ==============
              _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Booking Details",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _detailRow("Plate Number", booking.plateNumber),
                    _detailRow("Location", booking.areaName),
                    _detailRow("Slot", booking.slot),
                    _detailRow("Check-in Time", booking.startTime),
                    _detailRow("Check-out Time", booking.endTime),
                    _detailRow("Specifications", "None"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ============== DIRECTIONS HINT ==============
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: "Don’t know the route? ",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                    children: [
                      TextSpan(
                        text: "Get Directions",
                        style: TextStyle(
                          color: kPrimaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// ============== VIEW HISTORY BUTTON ==============
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      fadeRoute(const ParkingHistoryScreen()),
                    );
                  },
                  child: const Text(
                    "View History",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // WHITE CARD WRAPPER
  // ============================
  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================
  // DETAIL ROW
  // ============================
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
