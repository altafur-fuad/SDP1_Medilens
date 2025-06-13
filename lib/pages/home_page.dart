import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logindemo/medicine/listpage.dart';
import 'package:logindemo/our_medicine/our_medicine_list_page.dart';
import 'package:logindemo/pages_from_home/drawer.dart';
import 'package:logindemo/pages_from_home/my_drug.dart';
import 'package:logindemo/pages_from_home/profilepage.dart';
import 'package:logindemo/pages_from_home/reaminderpage.dart';
import 'package:logindemo/pages_from_home/searchpage.dart';
import '../auth/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = FirebaseAuth.instance.currentUser;

    final List<Map<String, dynamic>> menuItems = [
      {'label': 'OUR MEDICINE', 'type': 'Our'},
      {'label': 'Indications', 'type': 'Indications'},
      {'label': 'Generic', 'type': 'Generic'},
      {'label': 'Brand', 'type': 'Brand'},
      {'label': 'Herbal', 'type': 'Herbal'},
      {'label': 'My Drug', 'type': 'MyDrug'},
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 57, 129, 174),
      drawer: drawer(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: const Text('Medi Lens'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black, size: 35),
            onPressed: () async {
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
        ],
      ),

      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Welcome to Engima of Medicine !!',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Center(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                childAspectRatio: 1.5,
                children:
                    menuItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          switch (item['type']) {
                            case 'MyDrug':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyDrugPage(),
                                ),
                              );
                              break;

                            case 'Our':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const OurMedicineListPage(
                                        filterBy: 'Generic',
                                      ),
                                ),
                              );
                              break;

                            case 'Indications':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const OurMedicineListPage(
                                        filterBy: 'Indication',
                                      ),
                                ),
                              );
                              break;

                            default:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ListPage(type: item['type']),
                                ),
                              );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 107, 171, 222),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBFD7ED)),
                          ),
                          child: Text(
                            item['label'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 40,
                color: const Color.fromARGB(255, 181, 201, 210),
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReminderPage()),
                  );
                },
              ),
              IconButton(
                iconSize: 40,
                color: const Color.fromARGB(255, 192, 206, 224),
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
