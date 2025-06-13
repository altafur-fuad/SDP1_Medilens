import 'package:flutter/material.dart';
import 'package:logindemo/auth/login_page.dart';
import 'package:logindemo/auth/signup_page.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 76, 145, 174),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(151, 255, 255, 255),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: const TabBarView(
                    children: [LoginPage(), SignupPage()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
