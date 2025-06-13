import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logindemo/auth/auth_screen.dart';
import 'package:logindemo/pages/intropage.dart';
import 'package:logindemo/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Map<String, String>> creators = [
    {'name': 'Fuad', 'image': 'assets/images/fuad.png'},
    {'name': 'Chandni', 'image': 'assets/images/chadni.jpg'},
    {'name': 'Nibrita', 'image': 'assets/images/nibrita.jpg'},
    {'name': 'Maysha', 'image': 'assets/images/maysha.jpg'},
    {'name': 'Pavel', 'image': 'assets/images/pavel.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashRedirector(),
    );
  }
}

class SplashRedirector extends StatefulWidget {
  const SplashRedirector({super.key});

  @override
  State<SplashRedirector> createState() => _SplashRedirectorState();
}

class _SplashRedirectorState extends State<SplashRedirector> {
  @override
  void initState() {
    super.initState();

    // Wait for 4 seconds then check login status and redirect
    Future.delayed(const Duration(seconds: 4), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Already logged in → Go to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        // Not logged in → Go to AuthScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Intropage(creators: MyApp.creators);
  }
}
