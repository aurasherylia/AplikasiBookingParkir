class Booking {
  final int? id;
  final String uniqueId;
  final String areaName;
  final String slot;
  final String startTime;
  final String endTime;
  final String createdAt;
  final int isActive;
  final String plateNumber;

  Booking({
    this.id,
    required this.uniqueId,
    required this.areaName,
    required this.slot,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.isActive,
    required this.plateNumber,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      uniqueId: map['uniqueId'],
      areaName: map['areaName'],
      slot: map['slot'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      createdAt: map['createdAt'],
      isActive: map['isActive'],
      plateNumber: map['plateNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
      'areaName': areaName,
      'slot': slot,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
      'isActive': isActive,
      'plateNumber': plateNumber,
    };
  }
}
