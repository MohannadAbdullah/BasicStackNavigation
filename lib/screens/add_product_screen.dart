import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/firestore_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final imageController = TextEditingController();

  final priceController = TextEditingController();

  final categoryController = TextEditingController();

  bool isLoading = false;

  // ================= ADD PRODUCT =================

  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final product = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),

        title: titleController.text.trim(),

        description: descriptionController.text.trim(),

        image: imageController.text.trim(),

        price: double.parse(priceController.text.trim()),

        category: categoryController.text.trim(),
      );

      await FirestoreService.addProduct(product);

      // ✅ تنظيف الحقول
      titleController.clear();

      descriptionController.clear();

      imageController.clear();

      priceController.clear();

      categoryController.clear();

      // ✅ Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,

          backgroundColor: Colors.green,

          content: const Text("Product Added Successfully"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product", style: TextStyle(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              // ================= TITLE =================
              TextFormField(
                controller: titleController,

                decoration: InputDecoration(
                  labelText: "Title",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter product title";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= DESCRIPTION =================
              TextFormField(
                controller: descriptionController,

                maxLines: 4,

                decoration: InputDecoration(
                  labelText: "Description",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter description";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= IMAGE =================
              TextFormField(
                controller: imageController,

                decoration: InputDecoration(
                  labelText: "Image URL",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter image url";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= PRICE =================
              TextFormField(
                controller: priceController,

                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  labelText: "Price",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter price";
                  }

                  if (double.tryParse(value) == null) {
                    return "Invalid price";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= CATEGORY =================
              TextFormField(
                controller: categoryController,

                decoration: InputDecoration(
                  labelText: "Category",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter category";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87743B),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: isLoading ? null : addProduct,

                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Add Product",

                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
