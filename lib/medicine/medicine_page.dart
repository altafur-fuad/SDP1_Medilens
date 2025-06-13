import 'package:flutter/material.dart';
import 'package:logindemo/provider_and_save/saved_medicines.dart';
import '../models/medicine.dart';
import 'details_page.dart';

class MedicinePage extends StatefulWidget {
  final List<FullMed> medicineList;
  final String title;
  final String type;
  final bool isBangla;

  const MedicinePage({
    super.key,
    required this.medicineList,
    required this.title,
    required this.type,
    required this.isBangla,
  });

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  @override
  void initState() {
    super.initState();
    SavedMedicines.loadSavedMedicinesFromFirebase().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text(
          '${widget.type}: ${widget.title} (${widget.isBangla ? "বাংলা" : "English"})',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: widget.medicineList.length,
        itemBuilder: (context, index) {
          final medicine = widget.medicineList[index];

          return Card(
            color: const Color.fromARGB(143, 166, 188, 199),
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
                          isBangla: widget.isBangla,
                        ),
                  ),
                );
              },
              trailing: StatefulBuilder(
                builder: (context, setLocalState) {
                  final isSaved = SavedMedicines.isSaved(medicine);

                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color:
                          isSaved
                              ? const Color.fromARGB(255, 47, 137, 185)
                              : Colors.black,
                    ),
                    onPressed: () async {
                      if (isSaved) {
                        await SavedMedicines.remove(medicine);
                      } else {
                        await SavedMedicines.add(medicine);
                      }
                      setLocalState(() {});
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
