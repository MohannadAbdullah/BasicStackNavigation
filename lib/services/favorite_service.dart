import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product_model.dart';

class FavoriteService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final FirebaseAuth auth = FirebaseAuth.instance;

  // ================= ADD =================

  static Future<void> addFavorite(Product product) async {
    final user = auth.currentUser;

    if (user == null) return;

    product.isFavorite = true;

    await firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(product.id)
        .set(product.toJson());
  }

  // ================= REMOVE =================

  static Future<void> removeFavorite(Product product) async {
    final user = auth.currentUser;

    if (user == null) return;

    await firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .doc(product.id)
        .delete();
  }

  // ================= GET =================

  static Stream<List<Product>> getFavorites() {
    final user = auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("favorites")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final product = Product.fromJson(doc.data());

            product.isFavorite = true;

            return product;
          }).toList();
        });
  }
}
