import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DetailScreen.dart';
import 'app_provider.dart';

class Product {
  final String name;
  final String image;
  final double price;
  final String category;
  bool isFavorite;
  int quantity;

  Product(this.name, this.image, this.price, this.category,
      {this.isFavorite = false, this.quantity = 1});
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = "All";

  List<Product> products = [
    Product("Jacket", "assets/images/clothing-1.png", 50, "Clothes"),
    Product("Backpack", "assets/images/clothing-2.png", 70, "Bags"),
    Product("Pants", "assets/images/clothing-3.png", 30, "Clothes"),
    Product("Short", "assets/images/clothing-4.png", 30, "Clothes"),
    Product("T-shirt", "assets/images/clothing-5.png", 20, "Clothes"),
    Product("Shoes", "assets/images/shoes1.png", 50, "Shoes"),
    Product("Shoes", "assets/images/shose.png", 50, "Shoes"),
    Product("Belt", "assets/images/belt.png", 10, "Accessories"),
    Product("Suitcase", "assets/images/Suitcase.png", 100, "Bags"),
    Product("Cap", "assets/images/Cap.png", 20, "Accessories"),
  ];

  List<String> categories = [
    "All",
    "Clothes",
    "Shoes",
    "Bags",
    "Accessories"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final filteredProducts = selectedCategory == "All"
        ? products
        : products
            .where((p) => p.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Store", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔹 الفئات
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selectedCategory == cat,
                    selectedColor: Color.fromARGB(255, 135, 116, 59),
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),

         
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: filteredProducts.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailScreen(product: product),
                      ),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Colors.black12,
                        )
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: product.name,
                            child: Image.asset(product.image),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),

                              SizedBox(height: 4),

                              Text("\$${product.price}",
                                  style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 135, 116, 59))),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      product.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: product.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      provider
                                          .toggleFavorite(product);
                                    },
                                  ),

                                  IconButton(
                                    icon: Icon(Icons.shopping_cart),
                                    onPressed: () {
                                      provider.addToCart(product);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Added to cart 🛒")),
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
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