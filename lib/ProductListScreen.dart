import 'package:flutter/material.dart';
import 'DetailScreen.dart';
import 'dart:ui';
class Product {
  final String name;
  final String image;
  final double price;
  bool isFavorite;

  Product(this.name, this.image, this.price, {this.isFavorite = false});
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [
    Product("Jacket", "assets/images/clothing-1.png", 50),
    Product("Backpack", "assets/images/clothing-2.png", 70),
    Product("Pants", "assets/images/clothing-3.png", 30),
    Product("Short", "assets/images/clothing-4.png", 30),
    Product("T-shirt", "assets/images/clothing-5.png",20),
    Product("Shoes", "assets/images/shose.png",50),
    Product("Shoes", "assets/images/shoes.webp",50),
    Product("Belt", "assets/images/belt.webp",10),
    Product("Suitcase", "assets/images/Suitcase.webp",100),
    Product("Cap", "assets/images/Cap.webp",20),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products",style: TextStyle(color: Color(0xFFF5F6FA)),),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: EdgeInsets.all(12),
              leading: Hero(
                tag: products[index],
                child: Image.asset(product.image, width: 60),
              ),

              title: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              subtitle: Text(
                "\$${product.price}",
                style: TextStyle(
                  color:  Color.fromARGB(255, 135, 116, 59),
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    product.isFavorite = !product.isFavorite;
                  });
                },),
            
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(product: product),
                  ),
                );
              
              

if (result  != null) {
  setState(() {});
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text("${product.name} Added to Favorite",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  });
}
}
              
            ),
          );
        },
      ),
    );
  }
}
