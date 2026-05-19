import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

import '../services/local_storage_service.dart';
import '../services/firestore_service.dart';
import '../services/favorite_service.dart';

class AppProvider extends ChangeNotifier {
  // ================= DATA =================

  List<Product> products = [];

  List<Product> favorites = [];

  List<Product> cart = [];

  bool isDarkMode = false;

  bool isOffline = false;

  // ✅ ADMIN
  bool isAdmin = false;

  // ================= INIT =================

  AppProvider() {
    loadLocalData();

    loadProductsRealtime();

    loadFavoritesRealtime();

    loadUserRole();
  }

  // ================= LOCAL DATA =================

  Future<void> loadLocalData() async {
    // 🛒 CART
    cart = await LocalStorageService.loadCart();

    // 🌙 THEME
    isDarkMode = await LocalStorageService.loadTheme();

    notifyListeners();
  }

  // ================= USER ROLE =================

  Future<void> loadUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      isAdmin = doc.data()?["role"] == "admin";

      notifyListeners();
    } catch (e) {
      isAdmin = false;
    }
  }

  // ================= PRODUCTS =================

  void loadProductsRealtime() {
    FirestoreService.getProducts().listen((data) {
      products = data;

      // ✅ مزامنة المفضلة
      for (var product in products) {
        if (favorites.any((f) => f.id == product.id)) {
          product.isFavorite = true;
        }
      }

      notifyListeners();
    });
  }

  // ================= FAVORITES =================

  Future<void> toggleFavorite(Product product) async {
    final index = favorites.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      favorites.removeAt(index);

      product.isFavorite = false;

      await FavoriteService.removeFavorite(product);
    } else {
      favorites.add(product);

      product.isFavorite = true;

      await FavoriteService.addFavorite(product);
    }

    notifyListeners();
  }

  void loadFavoritesRealtime() {
    FavoriteService.getFavorites().listen((data) {
      favorites = data;

      // ✅ مزامنة حالة المنتجات
      for (var product in products) {
        product.isFavorite = favorites.any((f) => f.id == product.id);
      }

      notifyListeners();
    });
  }

  // ================= CART =================

  void addToCart(Product product) {
    final index = cart.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      cart[index].quantity++;
    } else {
      final cartProduct = Product(
        id: product.id,

        title: product.title,

        description: product.description,

        image: product.image,

        price: product.price,

        category: product.category,

        isFavorite: product.isFavorite,
      );

      cart.add(cartProduct);
    }

    saveCart();

    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = cart.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      cart[index].quantity++;

      saveCart();

      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = cart.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      if (cart[index].quantity > 1) {
        cart[index].quantity--;
      } else {
        cart.removeAt(index);
      }

      saveCart();

      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    cart.removeWhere((p) => p.id == product.id);

    saveCart();

    notifyListeners();
  }

  // ================= SAVE CART =================

  void saveCart() {
    LocalStorageService.saveCart(cart);
  }

  // ================= TOTAL PRICE =================

  double get totalPrice {
    return cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // ================= THEME =================

  void toggleTheme() {
    isDarkMode = !isDarkMode;

    LocalStorageService.saveTheme(isDarkMode);

    notifyListeners();
  }
}
