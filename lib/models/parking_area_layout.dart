class ParkingAreaLayout {
  final String name;
  final List<String> carSlots;
  final List<String> bikeSlots;

  const ParkingAreaLayout({
    required this.name,
    required this.carSlots,
    required this.bikeSlots,
  });
}

const List<ParkingAreaLayout> kParkingLayouts = [
  ParkingAreaLayout(
    name: 'Parkiran FTI',
    carSlots: ['A1', 'A2', 'A3', 'A4', 'A5'],
    bikeSlots: ['M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9', 'M10'],
  ),
  ParkingAreaLayout(
    name: 'Parkiran Lapangan Volly',
    carSlots: ['V1', 'V2', 'V3'],
    bikeSlots: ['VM1', 'VM2', 'VM3', 'VM4', 'VM5', 'VM6'],
  ),
  ParkingAreaLayout(
    name: 'Parkiran Lapangan Basket',
    carSlots: ['B1', 'B2', 'B3', 'B4'],
    bikeSlots: ['BM1', 'BM2', 'BM3', 'BM4', 'BM5', 'BM6', 'BM7'],
  ),
];
