import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uasppb_2021130007/models/resto.dart';

class FirestoreService {
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  Future<void> saveOrder(Resto resto) async {
    await orders.add({
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
    });
  }
}
