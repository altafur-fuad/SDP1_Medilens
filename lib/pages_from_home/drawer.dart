import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logindemo/auth/auth_screen.dart';
import 'package:logindemo/contact/contactpage.dart';
import 'package:logindemo/contact/creatorlist.dart';
import 'package:logindemo/medicine/listpage.dart';
import 'package:logindemo/pages_from_home/profilepage.dart';

// ignore: camel_case_types
class drawer extends StatelessWidget {
  const drawer({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 33, 103, 159)),
            child: Text(
              'Medi App Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Account'),
            leading: const Icon(Icons.person),
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              // Try to fetch from both collections
              final maleDoc =
                  await FirebaseFirestore.instance
                      .collection('users_male')
                      .doc(uid)
                      .get();
              final femaleDoc =
                  await FirebaseFirestore.instance
                      .collection('users_female')
                      .doc(uid)
                      .get();

              final userData =
                  maleDoc.exists
                      ? maleDoc.data()!
                      : femaleDoc.exists
                      ? femaleDoc.data()!
                      : null;

              if (userData != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => Profilepage(
                          creator: {
                            'name': userData['name'],
                            'email': userData['email'],
                            'dob': userData['dob'],
                            'mobile': userData['mobile'],
                            'gender': userData['gender'],
                            'age': userData['age'].toString(),
                          },
                        ),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('Generic'),
            leading: const Icon(Icons.medical_services),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListPage(type: 'Generic'),
                  ),
                ),
          ),
          ListTile(
            title: const Text('Contact Us'),
            leading: const Icon(Icons.contact_mail),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactPage(creators: creators),
                ),
              );
            },
          ),

          ListTile(
            title: const Text('Logout'),
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
