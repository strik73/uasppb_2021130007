import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/models/cart_item.dart';

import 'food.dart';

class Resto extends ChangeNotifier {
  String? customerName;

  void setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  //list makanan
  final List<Food> _menu = [
    Food(
      name: 'Beef Steak',
      description: 'Steak dengan saus barbeque',
      imagePath: 'lib/images/mainCourse/steak.jpg',
      price: 38000,
      category: FoodCategory.mainCourse,
    ),
    Food(
      name: 'Nasi Goreng',
      description: 'Nasi goreng dengan telur',
      imagePath: 'lib/images/mainCourse/nasgor.jpg',
      price: 25000,
      category: FoodCategory.mainCourse,
    ),
    Food(
      name: 'Burger',
      description: 'Burger dengan daging sapi dan keju',
      imagePath: 'lib/images/mainCourse/burger.jpg',
      price: 32000,
      category: FoodCategory.mainCourse,
    ),
    //pasta
    Food(
      name: 'Bulgonaise Spaghetti',
      description: 'Spaghetti Italia dengan saus pasta',
      imagePath: 'lib/images/pasta/spaghetti.jpg',
      price: 35000,
      category: FoodCategory.pasta,
    ),
    Food(
      name: 'Pasta',
      description: 'Pasta khas Italia',
      imagePath: 'lib/images/pasta/pasta.jpg',
      price: 35000,
      category: FoodCategory.pasta,
    ),
    //salad
    Food(
      name: 'Veggie Salad',
      description: 'Salad dengan sayuran segar',
      imagePath: 'lib/images/salads/salad.jpg',
      price: 22000,
      category: FoodCategory.salads,
    ),
    Food(
      name: 'Egg Salad',
      description: 'Salad dengan telur',
      imagePath: 'lib/images/salads/egg_salad.jpg',
      price: 24000,
      category: FoodCategory.salads,
    ),
    //desserts
    Food(
      name: 'Pudding',
      description: 'Puding dengan susu dan keju',
      imagePath: 'lib/images/desserts/pudding.jpg',
      price: 24000,
      category: FoodCategory.desserts,
    ),
    //drinks
    Food(
      name: 'Coffee Latte',
      description: 'Kopi arabica dengan susu',
      imagePath: 'lib/images/drinks/coffee.jpg',
      price: 24000,
      category: FoodCategory.drinks,
    ),
    Food(
      name: 'Affogato',
      description: 'Kopi espresso dengan es krim',
      imagePath: 'lib/images/drinks/affogato.jpg',
      price: 28000,
      category: FoodCategory.drinks,
    ),
    Food(
      name: 'Orange Juice',
      description: 'Jus segar dari jeruk',
      imagePath: 'lib/images/drinks/orange.jpg',
      price: 18000,
      category: FoodCategory.drinks,
    ),
  ];

  //ubah nomor meja
  String _tableNumber = '1';

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

  //ubah nomor meja
  void setTableNumber(String tableNumber) {
    _tableNumber = tableNumber;
    notifyListeners();
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
