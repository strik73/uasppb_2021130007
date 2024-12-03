import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'food.dart';

class Resto extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Food> _menu = [];

  //method to fetch foods
  Future<void> fetchMenu() async {
    try {
      final snapshot = await _firestore.collection('foods').get();
      _menu =
          snapshot.docs.map((doc) => Food.fromFirestore(doc.data())).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching menu: $e');
    }
  }

  String? customerName;
  String _tableNumber = '1';
  String? paymentMethod;

  void setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  void setPaymentMethod(String payment) {
    paymentMethod = payment;
    notifyListeners();
  }

  //getter
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get tableNumber => _tableNumber;

  //function add to cart
  final List<CartItem> _cart = [];

  void addToCart(Food food) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      return isSameFood;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food));
    }
    notifyListeners();
  }

  //function remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);
    if (cartIndex != -1) {
      if (cartItem.quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
      notifyListeners();
    }
  }

  //getter
  double getTotalPrice() {
    double totalPrice = 0;
    for (CartItem cartItem in _cart) {
      totalPrice += cartItem.food.price * cartItem.quantity;
    }
    return totalPrice;
  }

  int getTotalQuantity() {
    int totalQuantity = 0;
    for (CartItem cartItem in _cart) {
      totalQuantity += cartItem.quantity;
    }
    return totalQuantity;
  }

  //clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setTableNumber(String tableNumber) {
    _tableNumber = tableNumber;
    notifyListeners();
  }

  //metode pembayaran
  String getPaymentInstructions() {
    switch (paymentMethod) {
      case 'Cash':
        return "Please pay at the cashier counter.";
      case 'Transfer Bank':
        return "BANK";
      case 'Qris':
        return "QRIS";
      default:
        return "";
    }
  }

  //bon pembayaran
  String displayBon() {
    final bon = StringBuffer();
    bon.writeln("Bukti Pembayaran");
    bon.writeln("------------------------------------");
    bon.writeln();

    String formattedDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    bon.writeln(formattedDate);
    bon.writeln();

    if (customerName != null && customerName!.isNotEmpty) {
      bon.writeln("Customer: $customerName");
      bon.writeln("Table: $tableNumber");
      bon.writeln("Payment Method: $paymentMethod");
      bon.writeln();
    }

    bon.writeln("------------------------------------");

    for (final item in _cart) {
      double foodTotalPrice = item.quantity * item.food.price;
      bon.writeln(
          "${item.quantity} x ${item.food.name} - ${_formatPrice(foodTotalPrice)}");
      bon.writeln();
    }

    bon.writeln("------------------------------------");
    bon.writeln("");
    bon.writeln("Total Items: ${getTotalQuantity()}");
    bon.writeln("Total Price: ${_formatPrice(getTotalPrice())}");

    return bon.toString();
  }

  String _formatPrice(double price) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp.', decimalDigits: 2)
        .format(price);
  }
}
