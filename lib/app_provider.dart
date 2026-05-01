import 'package:flutter/material.dart';
import 'ProductListScreen.dart';

class AppProvider extends ChangeNotifier {
  List<Product> favorites = [];
  List<Product> cart = [];

bool isDarkMode = false;

// 🔄 تبديل الوضع
void toggleTheme() {
  isDarkMode = !isDarkMode;
  notifyListeners();
}
  // ❤️ إضافة/إزالة من المفضلة
  void toggleFavorite(Product product) {
    if (favorites.contains(product)) {
      favorites.remove(product);
      product.isFavorite = false;
    } else {
      favorites.add(product);
      product.isFavorite = true;
    }
    notifyListeners();
  }

  // 🛒 إضافة للسلة
  void addToCart(Product product) {
    if (!cart.contains(product)) {
      cart.add(product);
      notifyListeners();
    }
  }

  // 💰 حساب المجموع
  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + item.price);
  // ➕ زيادة الكمية
void increaseQuantity(Product product) {
  product.quantity++;
  notifyListeners();
}

// ➖ تقليل الكمية
void decreaseQuantity(Product product) {
  if (product.quantity > 1) {
    product.quantity--;
  } else {
    cart.remove(product); // حذف إذا وصلت 1
  }
  notifyListeners();
}


void removeFromCart(Product product) {
  cart.remove(product);
  notifyListeners();
}
}
