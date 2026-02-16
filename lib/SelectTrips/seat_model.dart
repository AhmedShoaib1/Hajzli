import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ لاستخدام Timestamp

enum SeatStatus { available, booked, temporary, unavailable }

enum Gender { male, female, none }

enum SeatType { normal, vip }

enum SeatPosition { window, aisle, left, right }

class Seat {
  final String id;
  final int seatId;
  SeatStatus status;
  Gender gender;
  final SeatType type;
  final SeatPosition position;
  final int row;
  final int column;
  final DateTime? holdUntil;

  Seat({
    required this.id,
    required this.seatId,
    required this.status,
    required this.gender,
    required this.type,
    required this.position,
    required this.row,
    required this.column,
    this.holdUntil,
  });

  factory Seat.fromMap(Map<String, dynamic> map, String docId) {
    return Seat(
      id: docId,
      seatId: map['seatId'] ?? 0,
      status: _parseStatus(map['status']),
      gender: _parseGender(map['gender']),
      type: map['type'] == 'vip' ? SeatType.vip : SeatType.normal,
      position: _parsePosition(map['position']),
      row: map['row'] ?? 0,
      column: map['column'] ?? 0,
      holdUntil: map['holdUntil'] != null
          ? (map['holdUntil'] as Timestamp).toDate()
          : null,
    );
  }

  static SeatStatus _parseStatus(String? s) {
    switch (s) {
      case 'booked':
        return SeatStatus.booked;
      case 'temporary':
        return SeatStatus.temporary;
      case 'unavailable':
        return SeatStatus.unavailable;
      default:
        return SeatStatus.available;
    }
  }

  static Gender _parseGender(String? s) {
    if (s == 'male') return Gender.male;
    if (s == 'female') return Gender.female;
    return Gender.none;
  }

  static SeatPosition _parsePosition(String? s) {
    switch (s) {
      case 'window':
        return SeatPosition.window;
      case 'aisle':
        return SeatPosition.aisle;
      case 'left':
        return SeatPosition.left;
      case 'right':
        return SeatPosition.right;
      default:
        return SeatPosition.window;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'seatId': seatId,
      'status': status.toString().split('.').last,
      'gender':
          gender != Gender.none ? gender.toString().split('.').last : null,
      'type': type == SeatType.vip ? 'vip' : 'normal',
      'position': position.toString().split('.').last,
      'row': row,
      'column': column,
      'holdUntil': holdUntil != null ? Timestamp.fromDate(holdUntil!) : null,
    };
  }

  bool get isAvailable => status == SeatStatus.available;
  bool get isBooked => status == SeatStatus.booked;
  bool get isTemporary => status == SeatStatus.temporary;
  bool get isUnavailable => status == SeatStatus.unavailable;
}
