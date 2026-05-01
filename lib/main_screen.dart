import 'package:flutter/material.dart';
import 'ProductListScreen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'setting.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          ProductListScreen(),  
          FavoritesScreen(),
          CartScreen(),
          // CategoriesScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Color.fromARGB(255, 135, 116, 59),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
           if (index == 3) {
            _showSettings(context); 
          } else {
            setState(() {
              currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "More"),
        ],
      ),
     
    );
    
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