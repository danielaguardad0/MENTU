import '../core/db_helper.dart';
import '../models/availability.dart';
import '../models/booking.dart';

class TutorService {
  Future<AvailabilityModel> createAvailability(AvailabilityModel a) async {
    final db = await DBHelper.instance.database;
    final id = await db.insert('availabilities', a.toMap());
    a.id = id;
    return a;
  }

  Future<List<AvailabilityModel>> getAvailabilitiesForTutor(int tutorId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query('availabilities',
        where: 'tutor_id = ?', whereArgs: [tutorId], orderBy: 'date ASC');
    return rows.map((r) => AvailabilityModel.fromMap(r)).toList();
  }

  Future<BookingModel> createBooking(BookingModel b) async {
    final db = await DBHelper.instance.database;
    final id = await db.insert('bookings', b.toMap());
    b.id = id;
    return b;
  }

  Future<List<BookingModel>> getBookingsForUser(int userId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query('bookings',
        where: 'student_id = ?', whereArgs: [userId], orderBy: 'date ASC');
    return rows.map((r) => BookingModel.fromMap(r)).toList();
  }

  Future<List<BookingModel>> getBookingsForTutor(int tutorId) async {
    final db = await DBHelper.instance.database;
    final rows = await db.query('bookings',
        where: 'tutor_id = ?', whereArgs: [tutorId], orderBy: 'date ASC');
    return rows.map((r) => BookingModel.fromMap(r)).toList();
  }

  Future<void> cancelBooking(int id) async {
    final db = await DBHelper.instance.database;
    await db.update('bookings', {'status': 'cancelled'},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> completeBooking(int id) async {
    final db = await DBHelper.instance.database;
    await db.update('bookings', {'status': 'completed'},
        where: 'id = ?', whereArgs: [id]);
  }
}
