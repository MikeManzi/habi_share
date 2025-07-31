import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> bookAppointment(Appointment appointment) async {
    try {
      final docRef = await _firestore.collection('appointments').add(appointment.toMap());
      await _firestore.collection('appointments').doc(docRef.id).update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  Future<List<Appointment>> getUserAppointments(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch appointments: $e');
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }
}