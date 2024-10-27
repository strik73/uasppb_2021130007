import 'package:flutter/material.dart';

import 'food.dart';

class Resto extends ChangeNotifier {
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

//getter
  List<Food> get menu => _menu;
}
