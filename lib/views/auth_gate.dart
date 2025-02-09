import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const HomeScreen(); // User sudah login langsung ke homescreen
          } else {
            return const LoginScreen(); // User belum login pergi ke halaman login
          }
        }
        return const Center(child: CircularProgressIndicator()); // Loading state
      },
    );
  }
}
