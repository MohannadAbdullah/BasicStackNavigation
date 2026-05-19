import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class FirestoreService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ================= PRODUCTS =================

  static Future<void> addProduct(Product product) async {
    try {
      print("Before Firestore");

      await firestore
          .collection("products")
          .doc(product.id)
          .set(product.toJson());

      print("Added Successfully");
    } catch (e, s) {
      print("====================");
      print("ERROR:");
      print(e);
      print("STACK:");
      print(s);
      print("====================");

      rethrow;
    }
  }

  static Stream<List<Product>> getProducts() {
    return firestore.collection("products").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson(doc.data());
      }).toList();
    });
  }

  static Future<void> deleteProduct(String id) async {
    await firestore.collection("products").doc(id).delete();
  }
}
