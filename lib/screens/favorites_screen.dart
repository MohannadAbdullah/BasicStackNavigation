import 'package:flutter/material.dart';
import 'package:mostore/screens/ProductListScreen.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/app_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorites",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Selector<AppProvider, List<Product>>(
        selector: (_, p) => p.favorites,
        shouldRebuild: (prev, next) {
          if (prev.length != next.length) return true;
          for (int i = 0; i < prev.length; i++) {
            if (prev[i].id != next[i].id) return true;
          }
          return false;
        },
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Found",
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];

              return Dismissible(
                key: Key(product.id.toString()),
                direction: DismissDirection.endToStart,

                // 🔴 الخلفية
                background: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.only(right: 25),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 35,
                  ),
                ),

                // 🗑 عند الحذف
                onDismissed: (_) {
                  context.read<AppProvider>().toggleFavorite(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${product.title} removed",
                      ),
                    ),
                  );
                },

                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      product.image,
                      width: 60,
                    ),
                    title: Text(product.title),
                    subtitle: Text(
                      "\$${product.price}",
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}