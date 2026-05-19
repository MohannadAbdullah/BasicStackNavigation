import 'package:flutter/material.dart';
import 'package:mostore/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/app_provider.dart';
import 'screens/login_screen.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return Selector<AppProvider, bool>(
      selector: (_, p) => p.isDarkMode,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // ---------- LIGHT ----------
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,

            appBarTheme: const AppBarTheme(
              backgroundColor:
                  Color.fromARGB(255, 135, 116, 59),
              foregroundColor: Colors.white,
            ),

            scaffoldBackgroundColor:
                const Color(0xFFF5F6FA),

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF87743B),
              surface: Colors.white,
            ),

            cardTheme: const CardThemeData(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.all(8),
            ),
          ),

          // ---------- DARK ----------
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,

            scaffoldBackgroundColor: Colors.black,

            colorScheme: const ColorScheme.dark(
              surface: const Color(0xFF1E1E1E),
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),

            elevatedButtonTheme:
                ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF1E1E1E),
              ),
            ),

            cardTheme: const CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 0,
              margin: EdgeInsets.all(8),
            ),
          ),

          // ---------- THEME MODE ----------
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

          home: const AuthGate(),
        );
      },
    );
  }
}