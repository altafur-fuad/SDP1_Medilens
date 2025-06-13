import 'package:flutter/material.dart';
import 'package:logindemo/models/ourmed_da.dart';

class OurDetailsPage extends StatelessWidget {
  final OurMedicine medicine;
  final bool isBangla;

  OurDetailsPage({super.key, required this.medicine, required this.isBangla});

  String label(String en, String bn) => isBangla ? bn : en;

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text(medicine.genericName, style: const TextStyle(fontSize: 25)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            _buildDetail(
              label("Brand Names", "ব্র্যান্ড নাম"),
              medicine.brandName.join(', '),
            ),
            _buildDetail(
              label("Generic Name", "জেনেরিক নাম"),
              medicine.genericName,
            ),
            _buildDetail(
              label("Dosage", "ডোজ বিবরণ"),
              medicine.dosageDescription,
            ),
            _buildDetail(
              label("Side Effects", "পার্শ্বপ্রতিক্রিয়া"),
              medicine.sideEffects.join(', '),
            ),
            _buildDetail(
              label("Indications", "প্রয়োগ ক্ষেত্র"),
              medicine.indication.join(', '),
            ),
            _buildDetail(
              label("Herbal Ingredients", "হারবাল উপাদান"),
              medicine.herbalIngredients.join(', '),
            ),
            _buildDetail(
              label("Chemicals", "রাসায়নিক উপাদান"),
              medicine.chemicals.join(', '),
            ),
            _buildDetail(
              label("Used for Animals", "প্রাণীর জন্য ব্যবহৃত"),
              medicine.animalUse
                  ? (isBangla ? "হ্যাঁ" : "Yes")
                  : (isBangla ? "না" : "No"),
            ),
            _buildDetail(
              label("Pharmaceutical", "ফার্মাসিউটিক্যাল"),
              medicine.pharmaceutica,
            ),
          ],
        ),
      ),
    );
  }
}
