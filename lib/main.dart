import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';
import 'app_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // --- الثيم الفاتح ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor:const  Color.fromARGB(255, 135, 116, 59),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF87743B),
          surface: Colors.white, // هذا اللون الذي سنستخدمه للـ Container
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          margin: EdgeInsets.all(8),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor:  Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF1E1E1E),),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme:  ElevatedButtonThemeData(
         style: ElevatedButton.styleFrom(
           backgroundColor:const Color(0xFF1E1E1E),
        )),
        // التعديل هنا أيضاً
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          elevation: 0,
          margin: EdgeInsets.all(8),
        ),
      ),

      themeMode: provider.isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      home:  MainScreen(),
    );
  }
}