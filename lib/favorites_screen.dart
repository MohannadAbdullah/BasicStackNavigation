import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Favorites",style: TextStyle(color: Colors.white)),),

      body: provider.favorites.isEmpty
          ? Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final product = provider.favorites[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),

                    // 🖼️ صورة
                    leading: Image.asset(product.image, width: 60),

                    // 📦 اسم + سعر
                    title: Text(product.name),
                    subtitle: Text(
                      "\$${product.price}",
                      style: TextStyle(color: Colors.green),
                    ),

                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.toggleFavorite(product);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}