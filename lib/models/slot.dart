class ParkingSlot {
  final String name;
  bool isBooked;

  ParkingSlot({
    required this.name,
    this.isBooked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isBooked': isBooked ? 1 : 0,
    };
  }

  factory ParkingSlot.fromMap(Map<String, dynamic> map) {
    return ParkingSlot(
      name: map['name'],
      isBooked: map['isBooked'] == 1,
    );
  }
}
