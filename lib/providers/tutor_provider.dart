import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/availability.dart';
import '../models/booking.dart';
import '../services/tutor_service.dart';

final tutorProvider = Provider<TutorService>((ref) => TutorService());

final availabilityListProvider =
    StateNotifierProvider<AvailabilityNotifier, List<AvailabilityModel>>(
        (ref) => AvailabilityNotifier());

class AvailabilityNotifier extends StateNotifier<List<AvailabilityModel>> {
  final TutorService _service = TutorService();

  AvailabilityNotifier() : super([]);

  Future<void> loadTutorAvailabilities(int tutorId) async {
    final list = await _service.getAvailabilitiesForTutor(tutorId);
    state = list;
  }

  Future<void> addAvailability(AvailabilityModel a) async {
    final created = await _service.createAvailability(a);
    state = [...state, created];
  }
}

final bookingListProvider =
    StateNotifierProvider<BookingNotifier, List<BookingModel>>(
        (ref) => BookingNotifier());

class BookingNotifier extends StateNotifier<List<BookingModel>> {
  final TutorService _service = TutorService();
  BookingNotifier() : super([]);

  Future<void> loadBookingsForUser(int userId) async {
    final list = await _service.getBookingsForUser(userId);
    state = list;
  }

  Future<void> createBooking(BookingModel b) async {
    final created = await _service.createBooking(b);
    state = [...state, created];
  }

  Future<void> cancelBooking(int id) async {
    await _service.cancelBooking(id);
    state = state
        .map((b) => b.id == id
            ? BookingModel(
                id: b.id,
                studentId: b.studentId,
                tutorId: b.tutorId,
                availabilityId: b.availabilityId,
                date: b.date,
                startTime: b.startTime,
                endTime: b.endTime,
                status: 'cancelled',
              )
            : b)
        .toList();
  }
}
