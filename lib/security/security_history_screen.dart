import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../db/database_helper.dart';
import '../../models/booking.dart';

class SecurityHistoryScreen extends StatelessWidget {
  const SecurityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: FutureBuilder<List<Booking>>(
        future: DatabaseHelper.instance.getAllBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen),
            );
          }

          final all = snapshot.data!;
          final active = all.where((b) => b.isActive == 1).toList();
          final completed = all.where((b) => b.isActive == 0).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Active Sessions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              if (active.isEmpty) _emptyCard("No Active Parking Session"),
              ...active.map((b) => _activeCard(b)).toList(),

              const SizedBox(height: 28),

              const Text("Completed Sessions",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              if (completed.isEmpty) _emptyCard("No Completed Data"),
              ...completed.map((b) => _completedCard(b)).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _activeCard(Booking b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kPrimaryGreen.withOpacity(0.22),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text("ACTIVE",
                style: TextStyle(
                    color: kPrimaryGreen, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 12),
          const Text("Aura Sherylia",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Text("Unique ID: ${b.uniqueId}",
              style: const TextStyle(color: kPrimaryGreen)),
          Text("Plate: ${b.plateNumber}"),   // <<--- NEW
          const SizedBox(height: 4),
          Text("Area: ${b.areaName}   -   Slot: ${b.slot}"),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoText("Check-in", b.startTime),
              _infoText("Check-out (Est)", b.endTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedCard(Booking b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: kPrimaryGreen, size: 28),
          const SizedBox(height: 8),

          const Text("Aura Sherylia",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          Text("Unique ID: ${b.uniqueId}",
              style: const TextStyle(color: kPrimaryGreen)),
          Text("Plate: ${b.plateNumber}"),   // <<--- NEW

          const SizedBox(height: 4),
          Text("Area: ${b.areaName}   -   Slot: ${b.slot}"),

          const SizedBox(height: 10),
          Text("Date: ${b.createdAt.split("T").first}"),

          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoText("Check-in", b.startTime),
              _infoText("Check-out", b.endTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(String txt) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Center(child: Text(txt, style: const TextStyle(color: Colors.grey))),
    );
  }

  Widget _infoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
