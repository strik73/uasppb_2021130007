import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  Future<void> saveOrder(String bon) async {
    await orders.add({
      'bon': bon,
      'date': DateTime.now(),
    });
  }
}
