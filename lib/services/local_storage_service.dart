import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/product_model.dart';

class LocalStorageService {

  // 📁 Get File
  static Future<File> _getFile(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$name.json");
  }

  // ================= PRODUCTS =================

  static Future<void> saveProducts(List<Product> products) async {
    final file = await _getFile("products");

    final jsonData = products.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<List<Product>> loadProducts() async {
    try {
      final file = await _getFile("products");

      if (!await file.exists()) return [];

      final content = await file.readAsString();

      final List data = jsonDecode(content);

      return data.map((e) {
        final product = Product.fromJson(e);

        product.quantity = e['quantity'] ?? 0;
        product.isFavorite = e['isFavorite'] ?? false;

        return product;
      }).toList();

    } catch (e) {
      return [];
    }
  }

  // ================= CART =================

  static Future<void> saveCart(List<Product> cart) async {
    final file = await _getFile("cart");

    final jsonData = cart.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<List<Product>> loadCart() async {
    try {
      final file = await _getFile("cart");

      if (!await file.exists()) return [];

      final content = await file.readAsString();

      final List data = jsonDecode(content);

      return data.map((e) {
        final product = Product.fromJson(e);

        product.quantity = e['quantity'] ?? 1;
        product.isFavorite = e['isFavorite'] ?? false;

        return product;
      }).toList();

    } catch (e) {
      return [];
    }
  }

  // ================= FAVORITES =================

  static Future<void> saveFavorites(List<Product> favorites) async {
    final file = await _getFile("favorites");

    final jsonData = favorites.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  static Future<List<Product>> loadFavorites() async {
    try {
      final file = await _getFile("favorites");

      if (!await file.exists()) return [];

      final content = await file.readAsString();

      final List data = jsonDecode(content);

      return data.map((e) {
        final product = Product.fromJson(e);

        product.isFavorite = true;

        return product;
      }).toList();

    } catch (e) {
      return [];
    }
  }
  static Future<void> saveTheme(bool isDark) async {
  final file = await _getFile("theme");

  await file.writeAsString(jsonEncode({"dark": isDark}));
}
static Future<bool> loadTheme() async {
  try {
    final file = await _getFile("theme");

    if (!await file.exists()) return false;

    final content = await file.readAsString();

    final data = jsonDecode(content);

    return data["dark"] ?? false;

  } catch (e) {
    return false;
  }
}
}