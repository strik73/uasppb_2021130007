import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:uasppb_2021130007/pages/add_menu_page.dart';
import 'package:uasppb_2021130007/models/food.dart';
import 'dart:io';

class AdminManageMenu extends StatefulWidget {
  const AdminManageMenu({super.key});

  @override
  State<AdminManageMenu> createState() => _AdminManageMenuState();
}

class _AdminManageMenuState extends State<AdminManageMenu> {
  @override
  void initState() {
    super.initState();
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  }

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  void deleteFood(Food food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${food.name}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('foods')
                    .doc(food.id)
                    .delete();

                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${food.name} has been deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Menu'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Add New Item',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMenuPage()),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('foods').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                Map<FoodCategory, List<Food>> groupedFoods = {};
                for (var doc in snapshot.data!.docs) {
                  Food food = Food.fromFirestore(
                      doc.data() as Map<String, dynamic>,
                      docId: doc.id);
                  if (!groupedFoods.containsKey(food.category)) {
                    groupedFoods[food.category] = [];
                  }
                  groupedFoods[food.category]!.add(food);
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: groupedFoods.length,
                    itemBuilder: (context, index) {
                      FoodCategory category =
                          groupedFoods.keys.elementAt(index);
                      List<Food> foods = groupedFoods[category]!;

                      return ExpansionTile(
                        title: Text(category.toString().split('.').last),
                        children: foods
                            .map((food) => ListTile(
                                  leading: Image.network(
                                    food.imagePath,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                  title: Text(food.name),
                                  subtitle: Text(
                                      currencyFormatter.format(food.price)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddMenuPage(
                                                        foodToEdit: food)),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          deleteFood(food);
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
