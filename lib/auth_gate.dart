import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mostore/screens/main_screen.dart';

import 'screens/login_screen.dart';
import 'main.dart';

class AuthGate extends StatelessWidget {

  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream:
          FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        // ⏳ Loading
        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        // ✅ User Logged In
        if (snapshot.hasData) {

          return MainScreen();
        }

        // ❌ Not Logged In
        return LoginScreen();
      },
    );
  }
}