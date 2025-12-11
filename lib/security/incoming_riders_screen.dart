import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../db/database_helper.dart';
import '../../models/booking.dart';
import '../security/scan_qr_screen.dart';

class IncomingRidesScreen extends StatefulWidget {
  const IncomingRidesScreen({super.key});

  @override
  State<IncomingRidesScreen> createState() => _IncomingRidesScreenState();
}

class _IncomingRidesScreenState extends State<IncomingRidesScreen> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = DatabaseHelper.instance.getActiveBookings();
  }

  void _refresh() {
    setState(() {
      _future = DatabaseHelper.instance.getActiveBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        title: const Text(
          "Incoming Rides",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<List<Booking>>(
        future: _future,
        builder: (context, s) {
          if (!s.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            );
          }

          final list = s.data!;
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ada kendaraan masuk.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final b = list[i];
              return _incomingCard(b);
            },
          );
        },
      ),
    );
  }

  Widget _incomingCard(Booking b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryGreen.withOpacity(.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "ACTIVE",
              style: TextStyle(
                color: kPrimaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),
          const Text(
            "Aura Sherylia",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 4),
          Text(
            "Unique ID: ${b.uniqueId}",
            style: const TextStyle(
              color: kPrimaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),
          _infoRow("Area Parkir", b.areaName),
          _infoRow("Slot", b.slot),

          _infoRow("Plate Number", b.plateNumber),   // <<--- NEW

          _infoRow("Check-in", b.startTime),
          _infoRow("Check-out (Est)", b.endTime),
          _infoRow("Specifications", "None"),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScanQrScreen(),
                  ),
                );
                _refresh();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
