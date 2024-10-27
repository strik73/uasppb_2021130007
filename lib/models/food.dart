class Food {
  Food({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.category,
  });

  final String name;
  final String imagePath;
  final double price;
  final String description;
  final FoodCategory category;
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
