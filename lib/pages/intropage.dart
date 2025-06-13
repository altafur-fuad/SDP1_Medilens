import 'package:flutter/material.dart';
import 'package:logindemo/pages/home_page.dart';

class Intropage extends StatelessWidget {
  const Intropage({super.key, required this.creators});

  final List<Map<String, String>> creators;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26658c),
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 180),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Logo'));
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enigma Of Medicine!!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text('Created By', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        creators.map((creator) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF264A6E),
                              child:
                                  creator['image'] != ''
                                      ? ClipOval(
                                        child: Image.asset(
                                          creator['image']!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      )
                                      : Text(
                                        creator['name']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
