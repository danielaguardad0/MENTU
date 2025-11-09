import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/tutor_provider.dart';
import '../models/availability.dart';
import '../models/booking.dart';

class TutorsScreen extends ConsumerStatefulWidget {
  const TutorsScreen({super.key});

  @override
  ConsumerState<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends ConsumerState<TutorsScreen> {
  final _dateCtrl = TextEditingController();
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final availList = ref.watch(availabilityListProvider);
    ref.watch(bookingListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tutorías & Reservas')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          if (user != null && user.role == 'tutor') ...[
            const Text('Crear disponibilidad (como tutor)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: _dateCtrl,
                decoration:
                    const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)')),
            TextField(
                controller: _startCtrl,
                decoration:
                    const InputDecoration(labelText: 'Hora inicio (HH:mm)')),
            TextField(
                controller: _endCtrl,
                decoration:
                    const InputDecoration(labelText: 'Hora fin (HH:mm)')),
            ElevatedButton(
                onPressed: () async {
                  final a = AvailabilityModel(
                      tutorId: int.parse(user.id),
                      date: _dateCtrl.text.trim(),
                      startTime: _startCtrl.text.trim(),
                      endTime: _endCtrl.text.trim());
                  await ref
                      .read(availabilityListProvider.notifier)
                      .addAvailability(a);
                  _dateCtrl.clear();
                  _startCtrl.clear();
                  _endCtrl.clear();
                },
                child: const Text('Guardar disponibilidad')),
            const SizedBox(height: 12),
            const Divider(),
          ],
          const Text('Disponibilidades',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: availList.isEmpty
                ? const Center(child: Text('Sin disponibilidades'))
                : ListView.builder(
                    itemCount: availList.length,
                    itemBuilder: (context, i) {
                      final a = availList[i];
                      return ListTile(
                        title:
                            Text('${a.date} • ${a.startTime} - ${a.endTime}'),
                        subtitle: Text('Tutor ID: ${a.tutorId}'),
                        trailing: user != null && user.role == 'student'
                            ? ElevatedButton(
                                onPressed: () async {
                                  // reservar
                                  final booking = BookingModel(
                                      studentId: int.parse(user.id),
                                      tutorId: a.tutorId,
                                      availabilityId: a.id!,
                                      date: a.date,
                                      startTime: a.startTime,
                                      endTime: a.endTime);
                                  await ref
                                      .read(bookingListProvider.notifier)
                                      .createBooking(booking);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Reserva creada')));
                                },
                                child: const Text('Reservar'),
                              )
                            : null,
                      );
                    },
                  ),
          )
        ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    if (user != null && user.role == 'tutor') {
      ref
          .read(availabilityListProvider.notifier)
          .loadTutorAvailabilities(int.parse(user.id));
      ref
          .read(bookingListProvider.notifier)
          .loadBookingsForUser(int.parse(user.id));
    } else if (user != null) {
      // estudiante: listar todas las disponibilidades (simple fetch of all tutors' availabilities)
      // For simplicity: load tutorId 1..n not implemented; availabilities are stored per tutor
      // We will just try to load availabilities for tutorId 1 as example
      ref.read(availabilityListProvider.notifier).loadTutorAvailabilities(1);
      ref
          .read(bookingListProvider.notifier)
          .loadBookingsForUser(int.parse(user.id));
    }
  }
}
