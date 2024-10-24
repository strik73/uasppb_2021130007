class Food {
  Food({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    required this.availableAddons,
  });

  final String name;
  final String image;
  final String price;
  final String description;
  final FoodCategory category;
  List<Addon> availableAddons;
}

enum FoodCategory {
  mainCourse,
  salads,
  pasta,
  desserts,
  drinks,
}

class Addon {
  final String name;
  final String price;

  Addon({
    required this.name,
    required this.price,
  });
}
