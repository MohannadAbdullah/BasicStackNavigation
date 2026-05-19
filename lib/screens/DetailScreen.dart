import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/app_provider.dart';

class DetailScreen extends StatelessWidget {

  final Product product;

  const DetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(color: Colors.white),
        ),

        actions: [
          // ❤️ Favorite
          Selector<AppProvider, bool>(
            selector: (_, p) => p.favorites.any((f) => f.id == product.id),
            builder: (context, isFavorite, _) {
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  context.read<AppProvider>().toggleFavorite(product);
                },
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // 🖼️ صورة المنتج
            Container(
              height: 320,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.white,
              ),

              child: Hero(
                tag: product.id,

                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      product.category.toUpperCase(),
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    product.title,

                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),
                  Text(
                    "\$${product.price}",

                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 25),
                  Text(
                    "${product.description}",
                    maxLines: 2,
                     overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40),

                  // 🛒 زر السلة
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton.icon(

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(
                                255,
                                135,
                                116,
                                59,
                              ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: () {

                        context.read<AppProvider>().addToCart(product);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          SnackBar(
                            behavior:
                                SnackBarBehavior.floating,

                            content: Text(
                              "Added to cart 🛒",
                            ),
                          ),
                        );
                      },

                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),

                      label: Text(
                        "Add To Cart",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}