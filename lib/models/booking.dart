class BookingModel {
  int? id;
  int studentId;
  int tutorId;
  int availabilityId;
  String date;
  String startTime;
  String endTime;
  String status; // booked/completed/cancelled

  BookingModel({
    this.id,
    required this.studentId,
    required this.tutorId,
    required this.availabilityId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = 'booked',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'student_id': studentId,
        'tutor_id': tutorId,
        'availability_id': availabilityId,
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
      };

  factory BookingModel.fromMap(Map<String, dynamic> m) => BookingModel(
        id: m['id'] as int?,
        studentId: m['student_id'] as int,
        tutorId: m['tutor_id'] as int,
        availabilityId: m['availability_id'] as int,
        date: m['date'] as String,
        startTime: m['start_time'] as String,
        endTime: m['end_time'] as String,
        status: m['status'] as String,
      );
}
