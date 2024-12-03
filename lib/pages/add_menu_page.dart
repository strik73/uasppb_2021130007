import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uasppb_2021130007/models/food.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMenuPage extends StatefulWidget {
  final Food? foodToEdit;
  const AddMenuPage({super.key, this.foodToEdit});

  @override
  State<AddMenuPage> createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  FoodCategory _selectedCategory = FoodCategory.mainCourse;
  bool _isLoading = false;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.foodToEdit != null) {
      _nameController.text = widget.foodToEdit!.name;
      _priceController.text = widget.foodToEdit!.price.toString();
      _descriptionController.text = widget.foodToEdit!.description;
      _selectedCategory = widget.foodToEdit!.category;
      _existingImageUrl = widget.foodToEdit!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _existingImageUrl = null; //clear existing image URL
      });
    }
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null && _existingImageUrl == null) return;

    setState(() => _isLoading = true);
    try {
      // Normalize the input name by removing spaces and converting to lowercase
      final normalizedName =
          _nameController.text.toLowerCase().replaceAll(' ', '');

      // Get all menu items
      final menuItems =
          await FirebaseFirestore.instance.collection('foods').get();

      // Check for duplicates by comparing normalized names
      final isDuplicate = widget.foodToEdit != null
          ? menuItems.docs.any((doc) =>
              doc.data()['name'].toString().toLowerCase().replaceAll(' ', '') ==
                  normalizedName &&
              doc.id != widget.foodToEdit!.id)
          : menuItems.docs.any((doc) =>
              doc.data()['name'].toString().toLowerCase().replaceAll(' ', '') ==
              normalizedName);

      if (isDuplicate) {
        throw Exception('A menu item with this name already exists');
      }

      String finalImageUrl = _existingImageUrl ?? '';

      if (_imageFile != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('https://api.imgur.com/3/image'),
        );
        request.headers['Authorization'] = 'Client-ID beb3d02d3db928c';
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final imgurResponse = jsonDecode(responseData);
          finalImageUrl = imgurResponse['data']?['link'] ?? '';
          if (finalImageUrl.isEmpty) {
            throw Exception('Failed to retrieve image URL from Imgur.');
          }
        }
      }

      final data = {
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'description': _descriptionController.text,
        'category': _selectedCategory.toString(),
        'imagePath': finalImageUrl,
      };

      if (widget.foodToEdit != null) {
        await FirebaseFirestore.instance
            .collection('foods')
            .doc(widget.foodToEdit!.id)
            .update(data);
      } else {
        await FirebaseFirestore.instance.collection('foods').add(data);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.foodToEdit != null ? 'Edit Menu Item' : 'Add New Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200)
            else if (_existingImageUrl != null)
              Image.network(_existingImageUrl!, height: 200)
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Text('No image selected')),
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter name' : null,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter price' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please enter description' : null,
            ),
            DropdownButtonFormField<FoodCategory>(
              value: _selectedCategory,
              items: FoodCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveMenu,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.foodToEdit != null
                      ? 'Update Menu Item'
                      : 'Save Menu Item'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
