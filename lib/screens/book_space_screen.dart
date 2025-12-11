import 'package:flutter/material.dart';

import '../constants.dart';
import '../db/database_helper.dart';
import '../models/booking.dart';
import '../models/parking_area_layout.dart';
import '../routes/custom_routes.dart';
import 'success_booking_screen.dart';

class BookSpaceScreen extends StatefulWidget {
  final ParkingAreaLayout parkingArea;
  final String selectedSlot;

  const BookSpaceScreen({
    super.key,
    required this.parkingArea,
    required this.selectedSlot,
  });

  @override
  State<BookSpaceScreen> createState() => _BookSpaceScreenState();
}

class _BookSpaceScreenState extends State<BookSpaceScreen> {
  /// TIME PICKER ------------------------------------------------------
  int _selectedTimeIndex = 2; // default 12.00
  final List<String> _times = ['07.00', '09.00', '12.00', '15.00'];

  /// INPUT PLAT NOMOR -------------------------------------------------
  final TextEditingController _plateController = TextEditingController();

  String get _selectedTime => _times[_selectedTimeIndex];

  String get _checkoutTime {
    final p = _selectedTime.split('.');
    int hour = int.parse(p[0]);
    int minute = int.parse(p[1]);

    hour = (hour + 2) % 24;

    return '${hour.toString().padLeft(2, '0')}.${minute.toString().padLeft(2, '0')}';
  }

  /// ==================================================================
  /// BOOK NOW
  /// ==================================================================
  Future<void> _bookSpace() async {
    if (_plateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan plat nomor terlebih dahulu!")),
      );
      return;
    }

    final newBooking = Booking(
      id: null,
      uniqueId: "",
      areaName: widget.parkingArea.name,
      slot: widget.selectedSlot,
      startTime: _selectedTime,
      endTime: _checkoutTime,
      createdAt: DateTime.now().toIso8601String(),
      isActive: 1,
      plateNumber: _plateController.text.trim().toUpperCase(),
    );

    /// Database return Booking lengkap (id + uniqueId sudah final)
    Booking savedBooking = await DatabaseHelper.instance.insertBooking(newBooking);

    if (!mounted) return;

    Navigator.push(
      context,
      fadeRoute(
        SuccessBookingScreen(booking: savedBooking),
      ),
    );
  }

  /// UI ==================================================================
 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(       // <<--- FIX OVERFLOW
        padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            _titleCard("Konfirmasi Slot Parkir"),
            const SizedBox(height: 16),

            _whiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.parkingArea.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryGreen,
                    ),
                  ),

                  const SizedBox(height: 6),
                  Text("Slot: ${widget.selectedSlot}"),

                  const SizedBox(height: 20),
                  const Text("Plat Nomor",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),

                  TextField(
                    controller: _plateController,
                    decoration: InputDecoration(
                      hintText: "contoh: AB 1234 CD",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text("Time",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),

                  Row(
                    children: List.generate(_times.length, (i) {
                      final selected = i == _selectedTimeIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTimeIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 38,
                            margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? kPrimaryGreen
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                _times[i],
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                  const Text("Check-out Time:",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),

                  Text(
                    _checkoutTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _bookSpace,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book Space",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}


  Widget _titleCard(String title) {
    return _whiteCard(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}
