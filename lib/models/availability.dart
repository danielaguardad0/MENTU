class AvailabilityModel {
  int? id;
  int tutorId;
  String date; // yyyy-MM-dd
  String startTime; // HH:mm
  String endTime;

  AvailabilityModel({
    this.id,
    required this.tutorId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'tutor_id': tutorId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
      };

  factory AvailabilityModel.fromMap(Map<String, dynamic> m) =>
      AvailabilityModel(
        id: m['id'] as int?,
        tutorId: m['tutor_id'] as int,
        date: m['date'] as String,
        startTime: m['start_time'] as String,
        endTime: m['end_time'] as String,
      );
}
