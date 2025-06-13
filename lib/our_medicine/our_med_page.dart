import 'package:flutter/material.dart';
import 'package:logindemo/models/ourmed_da.dart';
import 'our_details_page.dart';

class OurMedicinePage extends StatelessWidget {
  final List<OurMedicine> medicineList;
  final String title;
  final bool isBangla;

  const OurMedicinePage({
    super.key,
    required this.medicineList,
    required this.title,
    required this.isBangla,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text('${isBangla ? "ওষুধ তালিকা" : "Our Medicine"}: $title'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: medicineList.length,
        itemBuilder: (context, index) {
          final medicine = medicineList[index];
          return Card(
            color: const Color.fromARGB(143, 166, 188, 199),
            child: ListTile(
              title: Text(
                '${isBangla ? "ব্র্যান্ড" : "Brands"}: ${medicine.brandName.join(', ')}',
              ),
              subtitle: Text(
                '${isBangla ? "ফার্মাসিউটিক্যাল" : "Pharma"}: ${medicine.pharmaceutica}',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => OurDetailsPage(
                          medicine: medicine,
                          isBangla: isBangla,
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
