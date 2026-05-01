import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart", style: TextStyle(color: Colors.white)),),

      body: provider.cart.isEmpty
    ? Center(child: Text("Cart is empty"))
    : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.cart.length,
              itemBuilder: (context, index) {
                final product = provider.cart[index];

                return Card(
  margin: EdgeInsets.all(10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        // 🖼️ الصورة
        Image.asset(product.image, width: 60),

        SizedBox(width: 10),

        // 📦 الاسم + السعر
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name),
              SizedBox(height: 5),
              Text(
                "\$${product.price}",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),

        // ➕➖ + الحذف
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    provider.decreaseQuantity(product);
                  },
                ),
                Text("${product.quantity}"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    provider.increaseQuantity(product);
                  },
                ),
              ],
            ),

            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                provider.removeFromCart(product);
              },
            ),
          ],
        ),
      ],
    ),
  ),
);
              },
            ),
          ),

          // 💰 الإجمالي
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Total: \$${provider.cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
            
    );
  }
}