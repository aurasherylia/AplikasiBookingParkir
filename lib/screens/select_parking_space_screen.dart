import 'package:flutter/material.dart';

import '../constants.dart';
import '../db/database_helper.dart';
import '../models/parking_area_layout.dart';
import '../routes/custom_routes.dart';
import '../widgets/app_drawer.dart';
import 'book_space_screen.dart';

class SelectParkingSpaceScreen extends StatefulWidget {
  const SelectParkingSpaceScreen({super.key});

  @override
  State<SelectParkingSpaceScreen> createState() =>
      _SelectParkingSpaceScreenState();
}

class _SelectParkingSpaceScreenState extends State<SelectParkingSpaceScreen> {
  ParkingAreaLayout _selectedArea = kParkingLayouts.first;
  String? _selectedSlot;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openBookSpace() async {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih salah satu slot")),
      );
      return;
    }

    Navigator.of(context).push(
      slideRoute(
        BookSpaceScreen(
          parkingArea: _selectedArea,
          selectedSlot: _selectedSlot!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Builder(
        builder: (innerContext) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kScreenPadding, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(innerContext).openDrawer(),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Parkir Kampus 2 UPN "Veteran" Yogyakarta',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                // BODY
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kScreenPadding, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// ---- DROPDOWN AREA ----
                        _whiteCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Pilih slot parkir",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.grey.shade400),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<ParkingAreaLayout>(
                                    value: _selectedArea,
                                    items: kParkingLayouts
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e.name.split(" ").last,
                                              style: const TextStyle(
                                                  fontSize: 12),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val == null) return;
                                      setState(() {
                                        _selectedArea = val;
                                        _selectedSlot = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Center(
                          child: Text(
                            "Mobil & Motor Slots Available",
                            style:
                                TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// ---- SLOT GRID ----
                        Expanded(
                          child: _whiteCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _slotColumn(
                                    title: "Mobil",
                                    slots: _selectedArea.carSlots,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: _slotColumn(
                                    title: "Motor",
                                    slots: _selectedArea.bikeSlots,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _selectedSlot == null
                              ? const SizedBox(height: 20)
                              : Text(
                                  "Slot terpilih: $_selectedSlot di ${_selectedArea.name}",
                                  key: ValueKey(_selectedSlot),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _openBookSpace,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// -----------------
  /// SLOT COLUMN
  /// -----------------
  Widget _slotColumn({
    required String title,
    required List<String> slots,
  }) {
    return FutureBuilder(
      future: _loadSlotStatuses(slots),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: kPrimaryGreen));
        }

        final Map<String, bool> booked = snapshot.data as Map<String, bool>;

        return Column(
          children: [
            Text(
              "$title Slots",
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: slots.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (_, index) {
                  final slot = slots[index];
                  final bool isBooked = booked[slot] ?? false;
                  final bool isSelected = slot == _selectedSlot;

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () => setState(() => _selectedSlot = slot),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.grey.shade400
                            : isSelected
                                ? Colors.white
                                : kPrimaryGreen,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? kPrimaryGreen : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          title == "Mobil"
                              ? Icons.directions_car
                              : Icons.two_wheeler,
                          color: isBooked
                              ? Colors.white70
                              : isSelected
                                  ? kPrimaryGreen
                                  : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Load booked/available status untuk setiap slot
  Future<Map<String, bool>> _loadSlotStatuses(List<String> slots) async {
    Map<String, bool> status = {};

    for (String slot in slots) {
      bool booked = await DatabaseHelper.instance
          .isSlotBooked(_selectedArea.name, slot);
      status[slot] = booked;
    }

    return status;
  }

  /// CARD WRAPPER
  Widget _whiteCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
}
