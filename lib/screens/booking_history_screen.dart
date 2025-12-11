import 'package:flutter/material.dart';

import '../constants.dart';
import '../db/database_helper.dart';
import '../models/booking.dart';
import '../routes/custom_routes.dart';
import 'booking_details_screen.dart';
import 'select_parking_space_screen.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  late Future<List<Booking>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = DatabaseHelper.instance.getAllBookings();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureBookings = DatabaseHelper.instance.getAllBookings();
    });
  }

  void _goBackToSelectParking() {
    Navigator.pushAndRemoveUntil(
      context,
      slideRoute(const SelectParkingSpaceScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goBackToSelectParking();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBackToSelectParking,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refresh,
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(kScreenPadding),
          child: FutureBuilder<List<Booking>>(
            future: _futureBookings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimaryGreen),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada booking.\nSilakan booking tempat parkir terlebih dahulu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final bookings = snapshot.data!;

              return ListView.separated(
                itemBuilder: (context, index) {
                  final booking = bookings[index];

                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        fadeRoute(BookingDetailsScreen(booking: booking)),
                      );
                    },
                    child: _animatedHistoryCard(booking),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: bookings.length,
              );
            },
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 CARD DENGAN UI LEBIH BAGUS + ANIMASI
  // -------------------------------------------------------
  Widget _animatedHistoryCard(Booking booking) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON STATUS
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryGreen.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_parking,
                  color: kPrimaryGreen, size: 26),
            ),

            const SizedBox(width: 12),

            // INFO KIRI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.areaName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Slot ${booking.slot}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ⭐ PLAT NOMOR BARU
                  Text(
                    "Plate: ${booking.plateNumber}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // INFO KANAN
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Time",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  "${booking.startTime} - ${booking.endTime}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
