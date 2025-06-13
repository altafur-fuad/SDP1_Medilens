// lib/pages_from_home/my_drug.dart
import 'package:flutter/material.dart';
import 'package:logindemo/provider_and_save/saved_medicines.dart';

import '../medicine/details_page.dart';

class MyDrugPage extends StatelessWidget {
  const MyDrugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final savedMeds = SavedMedicines.savedList;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 127, 189, 231),
      appBar: AppBar(
        title: const Text('My Drugs'),
        backgroundColor: Colors.transparent,
      ),
      body:
          savedMeds.isEmpty
              ? const Center(child: Text('No saved medicines.'))
              : ListView.builder(
                itemCount: savedMeds.length,
                itemBuilder: (context, index) {
                  final medicine = savedMeds[index];
                  return Card(
                    color: const Color.fromARGB(143, 112, 164, 190),
                    child: ListTile(
                      title: Text(medicine.brandName.join(', ')),
                      subtitle: Text(medicine.genericName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailsPage(
                                  medicine: medicine,
                                  isBangla: false,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
