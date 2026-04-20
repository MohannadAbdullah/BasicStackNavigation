import 'package:flutter/material.dart';
import 'ProductListScreen.dart';

class DetailScreen extends StatefulWidget {

  final Product product;
  DetailScreen({required this.product});

  

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<DetailScreen> {
  
  @override
  Widget build(BuildContext context) {
    final product = widget.product;

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
              "\$${product.price}",
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 135, 116, 59),
                  padding: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: widget.product.isFavorite
                ?null 
                :(){
                  setState(() {
                    widget.product.isFavorite = true;
                  });

                  Navigator.pop(context, true);
                },
                child: Text(
                  "Add to Favorites",
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
