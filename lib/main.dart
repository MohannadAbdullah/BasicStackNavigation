import 'package:flutter/material.dart';

import 'ProductListScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // textTheme: ,
        appBarTheme:const AppBarTheme(
        backgroundColor:  Color.fromARGB(255, 135, 116, 59),
        ),
        scaffoldBackgroundColor: Color(0xFFF5F6FA),
      ),
      debugShowCheckedModeBanner: false,
      home: ProductListScreen(),
      );
  }
}
