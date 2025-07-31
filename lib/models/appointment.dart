class Appointment {
  final String id;
  final String propertyId;
  final String userId;
  final DateTime date;
  final String timeSlot;
  final DateTime createdAt;
  final String status; // 'pending', 'confirmed', 'cancelled'

  Appointment({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.date,
    required this.timeSlot,
    required this.createdAt,
    this.status = 'pending',
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      propertyId: map['propertyId'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      timeSlot: map['timeSlot'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'timeSlot': timeSlot,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'status': status,
    };
  }
}