class Food {
  Food({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.category,
  });

  final String id;
  final String name;
  final String imagePath;
  final double price;
  final String description;
  final FoodCategory category;

  // Add factory constructor for Firebase
  factory Food.fromFirestore(Map<String, dynamic> data, {String? docId}) {
    return Food(
      id: docId ?? '',
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      category: FoodCategory.values.firstWhere(
        (e) => e.toString() == data['category'],
        orElse: () => FoodCategory.mainCourse,
      ),
    );
  }
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
