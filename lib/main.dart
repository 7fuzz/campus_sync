import 'package:campus_sync/views/auth_gate.dart';
import 'package:campus_sync/views/home_screen.dart';
import 'package:campus_sync/views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(), // Cek jika sudah login, langsung masuk ke aplikasi
      routes: {
        '/home': (context) => const HomeScreen(), 
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
