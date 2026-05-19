import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../providers/app_provider.dart';
import 'DetailScreen.dart';

// مساعد لمقارنة Set من المعرفات فقط — يمنع إعادة البناء غير الضرورية
class _CartFavState {
  final Set<String> cartIds;
  final Set<String> favIds;
  _CartFavState(this.cartIds, this.favIds);

  @override
  bool operator ==(Object other) =>
      other is _CartFavState &&
      cartIds.length == other.cartIds.length &&
      favIds.length == other.favIds.length &&
      cartIds.containsAll(other.cartIds) &&
      favIds.containsAll(other.favIds);

  @override
  int get hashCode => Object.hash(
        Object.hashAll(cartIds.toList()..sort()),
        Object.hashAll(favIds.toList()..sort()),
      );
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = "all";
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    // لا نستمع هنا — نقرأ فقط عند الحاجة للتنفيذ
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store", style: TextStyle(color: Colors.white)),
      ),

      body: StreamBuilder<List<Product>>(
        stream: FirestoreService.getProducts(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No Products Found", style: TextStyle(fontSize: 20)),
            );
          }

          List<Product> products = snapshot.data!;

          // استخراج التصنيفات
          List<String> categories = products
              .map((e) => e.category)
              .toSet()
              .toList();

          // فلترة
          List<Product> filtered = products.where((product) {
            final matchSearch =
                searchText.isEmpty ||
                product.title.toLowerCase().contains(searchText);

            final matchCategory =
                selectedCategory == "all" ||
                product.category.toLowerCase() ==
                    selectedCategory.toLowerCase();

            return matchSearch && matchCategory;
          }).toList();

          return Column(
            children: [
              // SEARCH
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                ),
              ),

              // CATEGORIES
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _categoryItem("all"),

                    ...categories.map((c) => _categoryItem(c)),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // GRID
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),

                  itemCount: filtered.length,

                  itemBuilder: (context, index) {
                    final product = filtered[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(product: product),
                          ),
                        );
                      },

                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),

                                child: Image.network(
                                  product.image,

                                  fit: BoxFit.cover,

                                  errorBuilder: (c, e, s) {
                                    return const Icon(Icons.image, size: 80);
                                  },
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    product.title,

                                    maxLines: 1,

                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  Text(
                                    "\$${product.price}",

                                    style: const TextStyle(
                                      color: Color(0xFF87743B),

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // ✅ Selector — يُعيد البناء فقط عند تغيّر
                                  // مجموعة معرّفات السلة أو المفضلة
                                  Selector<AppProvider, _CartFavState>(
                                    selector: (_, p) => _CartFavState(
                                      p.cart.map((e) => e.id).toSet(),
                                      p.favorites.map((e) => e.id).toSet(),
                                    ),
                                    builder: (context, state, _) {
                                      final isInCart =
                                          state.cartIds.contains(product.id);
                                      final isFav =
                                          state.favIds.contains(product.id);

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,

                                              color: isFav
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),

                                            onPressed: () {
                                              context
                                                  .read<AppProvider>()
                                                  .toggleFavorite(product);
                                            },
                                          ),

                                          IconButton(
                                            icon: Icon(
                                              isInCart
                                                  ? Icons.shopping_cart
                                                  : Icons.add_shopping_cart,

                                              color: isInCart
                                                  ? const Color(0xFF87743B)
                                                  : Colors.grey,
                                            ),

                                            onPressed: () {
                                              context
                                                  .read<AppProvider>()
                                                  .addToCart(product);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
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
          );
        },
      ),
    );
  }

  Widget _categoryItem(String category) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF87743B) : Colors.grey.shade300,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          category,

          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
