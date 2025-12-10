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
  int _selectedTimeIndex = 2;

  final List<String> _times = ['07.00', '09.00', '12.00', '15.00'];

  String get _selectedTime => _times[_selectedTimeIndex];

  String get _checkoutTime {
    final parts = _selectedTime.split('.');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    hour = (hour + 2) % 24;
    return '${hour.toString().padLeft(2, '0')}.${minute.toString().padLeft(2, '0')}';
  }

  Future<void> _bookSpace() async {
    // 1. Buat booking sementara (uniqueId kosong dulu)
    final booking = Booking(
      id: null,
      uniqueId: "",
      areaName: widget.parkingArea.name,
      slot: widget.selectedSlot,
      startTime: _selectedTime,
      endTime: _checkoutTime,
      createdAt: DateTime.now().toIso8601String(),
      isActive: 1,
    );

    // 2. Insert → dapat ID
    final newId = await DatabaseHelper.instance.insertBooking(booking);

    // 3. Ubah ID → Unique ID CPA-XXXX
    final uniqueCode = DatabaseHelper.instance.generateUniqueId(newId);

    // 4. Ambil booking yg sudah lengkap
    final realBooking =
        await DatabaseHelper.instance.getBookingByUniqueId(uniqueCode);

    if (realBooking == null) {
      debugPrint("❌ Booking tidak ditemukan setelah insert!");
      return;
    }

    if (!mounted) return;

    // 5. Navigate ke Success page
    Navigator.push(
      context,
      fadeRoute(SuccessBookingScreen(booking: realBooking)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 10),
              _cardTitle("Konfirmasi Slot Parkir"),
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
                          color: kPrimaryGreen),
                    ),

                    const SizedBox(height: 6),
                    Text("Slot: ${widget.selectedSlot}"),

                    const SizedBox(height: 20),
                    const Text("Time", style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),

                    Row(
                      children: List.generate(_times.length, (i) {
                        final selected = i == _selectedTimeIndex;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedTimeIndex = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 36,
                              margin: EdgeInsets.only(right: i == 3 ? 0 : 8),
                              decoration: BoxDecoration(
                                color: selected ? kPrimaryGreen : Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  _times[i],
                                  style: TextStyle(
                                    color: selected ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),
                    const Text("Check-out Time:",
                        style: TextStyle(fontWeight: FontWeight.w600)),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _checkoutTime,
                        key: ValueKey(_checkoutTime),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _bookSpace,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
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

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardTitle(String title) {
    return _whiteCard(
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
              offset: const Offset(0, 3))
        ],
      ),
      child: child,
    );
  }
}
