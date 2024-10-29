import 'package:uasppb_2021130007/models/food.dart';

class CartItem {
  CartItem({required this.food, this.quantity = 1});

  Food food;
  int quantity;

  double get totalPrice => food.price * quantity;
}
