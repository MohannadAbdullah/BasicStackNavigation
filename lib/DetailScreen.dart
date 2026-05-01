import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductListScreen.dart';
import 'app_provider.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  DetailScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // ✅ هنا المكان الصحيح
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: TextStyle(color: Colors.white)),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Hero(
              tag: product.name,
              child: Image.asset(product.image, height: 200),
            ),

            SizedBox(height: 20),

            Text(
              product.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              "\$${product.price} ",
              style: TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "High quality ${product.name} with modern design.",
              textAlign: TextAlign.center,
            ),

            Spacer(),

            // ❤️ زر المفضلة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.isFavorite
                      ? Colors.grey
                      : Color.fromARGB(255, 135, 116, 59),
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: product.isFavorite
                    ? null
                    : () {
                        provider.toggleFavorite(product);

                        Navigator.pop(context, true);
                      },

                child: Text(
                  product.isFavorite
                      ? "Already in Favorites ❤️"
                      : "Add to Favorites",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 10),

            // 🛒 زر السلة
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  provider.addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added to cart 🛒")),
                  );
                },
                child: Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}