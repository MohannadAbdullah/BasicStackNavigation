import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mostore/screens/add_product_screen.dart';
import 'ProductListScreen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'setting.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  String role = "user";
  bool isLoadingRole = true;

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      setState(() {
        role = doc['role'] ?? 'user';
        isLoadingRole = false;
      });
    } catch (e) {
      setState(() {
        role = 'user';
        isLoadingRole = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingRole) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          ProductListScreen(),
          FavoritesScreen(),
          CartScreen(),

          // 👇 فقط للأدمن
          if (role == 'admin') const AddProductScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 135, 116, 59),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == getMoreIndex()) {
            _showSettings(context);
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },

        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),

          // 👇 Add Product فقط للأدمن
          if (role == 'admin')
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Add Product",
            ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "More",
          ),
        ],
      ),
    );
  }

  int getMoreIndex() {
    return role == 'admin' ? 4 : 3;
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return SettingsSheet();
      },
    );
  }
}
