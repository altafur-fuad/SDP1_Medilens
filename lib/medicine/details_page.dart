import 'package:flutter/material.dart';
import 'package:logindemo/models/medicine.dart';

class DetailsPage extends StatelessWidget {
  final FullMed medicine;
  final bool isBangla;

  const DetailsPage({
    super.key,
    required this.medicine,
    required this.isBangla,
  });

  String label(String english, String bangla) => isBangla ? bangla : english;

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
        title: Text(medicine.genericName),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            _buildDetail(label("Strength", "ক্ষমতা"), medicine.strength),
            _buildDetail(label("Dosage", "ডোজ"), medicine.dosageDescription),
            _buildDetail(label("Price", "মূল্য"), medicine.price),
            _buildDetail(
              label("Manufacturer", "প্রস্তুতকারক"),
              medicine.manufacturer,
            ),
            _buildDetail(label("DAR", "ডিএআর নম্বর"), medicine.dar),
          ],
        ),
      ),
    );
  }
}
