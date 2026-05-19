import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/app_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.white)),
      ),

      body: Column(
        children: [
          // ✅ Selector — يُعيد البناء فقط عند تغيير عدد العناصر في السلة
          Expanded(
            child: Selector<AppProvider, List<Product>>(
              selector: (_, p) => List.unmodifiable(p.cart),
              shouldRebuild: (prev, next) {
                if (prev.length != next.length) return true;
                for (int i = 0; i < prev.length; i++) {
                  if (prev[i].id != next[i].id) return true;
                }
                return false;
              },
              builder: (context, cart, child) {
                if (cart.isEmpty) {
                  return const Center(
                    child: Text(
                      "Cart is Empty",
                      style: TextStyle(fontSize: 22),
                    ),
                  );
                }

                return ListView.builder(
                  key: const PageStorageKey("cart_list"),

                  itemCount: cart.length,

                  itemBuilder: (context, index) {
                    final product = cart[index];

                    return Card(
                      key: ValueKey(product.id),
                      margin: const EdgeInsets.all(8),

                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(Icons.image);
                          },
                        ),

                        title: Text(product.title),

                        subtitle: Selector<AppProvider, int>(
                          selector: (_, p) {
                            final item = p.cart.firstWhere(
                              (e) => e.id == product.id,
                              orElse: () => product,
                            );
                            return item.quantity;
                          },
                          builder: (context, quantity, _) {
                            final totalItemPrice = product.price * quantity;
                            return Text(
                              "\$${totalItemPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Color(0xFF87743B)),
                            );
                          },
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                context
                                    .read<AppProvider>()
                                    .decreaseQuantity(product);
                              },
                              icon: const Icon(Icons.remove),
                            ),

                            Selector<AppProvider, int>(
                              selector: (_, p) {
                                final item = p.cart.firstWhere(
                                  (e) => e.id == product.id,
                                  orElse: () => product,
                                );
                                return item.quantity;
                              },
                              builder: (context, quantity, _) {
                                return Text(
                                  "$quantity",
                                  style: const TextStyle(fontSize: 18),
                                );
                              },
                            ),

                            IconButton(
                              onPressed: () {
                                context
                                    .read<AppProvider>()
                                    .increaseQuantity(product);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ✅ Selector — يُعيد بناء السعر الإجمالي فقط عند تغيير totalPrice
          Selector<AppProvider, double>(
            selector: (_, p) => p.totalPrice,
            builder: (context, total, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Total: \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
