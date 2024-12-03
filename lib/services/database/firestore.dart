import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uasppb_2021130007/models/resto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
  final user = FirebaseAuth.instance.currentUser;

  Future<void> saveOrder(Resto resto) async {
    String timestamp =
        DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '');
    String orderId = 'ORD-${timestamp}-${user?.uid.substring(0, 3)}';

    await orders.doc(orderId).set({
      'userId': user?.uid,
      'orderId': orderId,
      'customerName': resto.customerName,
      'tableNumber': resto.tableNumber,
      'orderDate': DateTime.now(),
      'items': resto.cart
          .map((item) => {
                'name': item.food.name,
                'quantity': item.quantity,
                'price': item.food.price,
              })
          .toList(),
      'totalItems': resto.getTotalQuantity(),
      'totalPrice': resto.getTotalPrice(),
      'paymentMethod': resto.paymentMethod,
      'status': 'Pending',
    });
  }

  Stream<QuerySnapshot> getUserOrders() {
    return orders
        .where('userId', isEqualTo: user?.uid)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }
}
