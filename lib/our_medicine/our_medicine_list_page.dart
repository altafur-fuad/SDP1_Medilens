import 'package:flutter/material.dart';
import 'package:logindemo/models/ourmed_da.dart';
import 'package:logindemo/our_medicine/our_med_page.dart';
import '../provider_and_save/data_provider.dart';

class OurMedicineListPage extends StatefulWidget {
  final String filterBy; // 'Generic' or 'Indication'

  const OurMedicineListPage({super.key, required this.filterBy});

  @override
  State<OurMedicineListPage> createState() => _OurMedicineListPageState();
}

class _OurMedicineListPageState extends State<OurMedicineListPage> {
  List<OurMedicine> allData = [];
  List<String> allItems = [];
  List<String> filteredItems = [];
  bool isBangla = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    allData = await DataProvider.loadOurMedicine(bangla: isBangla);

    Set<String> itemSet = {};
    for (var med in allData) {
      if (widget.filterBy == 'Generic') {
        if (med.genericName.isNotEmpty) {
          itemSet.add(med.genericName);
        }
      } else if (widget.filterBy == 'Indication') {
        itemSet.addAll(med.indication.where((ind) => ind.isNotEmpty));
      }
    }

    setState(() {
      allItems = itemSet.toList()..sort();
      filteredItems = allItems;
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems =
          allItems
              .where((item) => item.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  List<OurMedicine> _getMatchedList(String value) {
    return allData.where((e) {
      if (widget.filterBy == 'Generic') {
        return e.genericName == value;
      } else {
        return e.indication.contains(value);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final titleText =
        widget.filterBy == 'Generic'
            ? (isBangla ? 'আমাদের ওষুধ' : 'Our Medicines')
            : (isBangla ? 'প্রয়োগ ক্ষেত্র অনুযায়ী' : 'By Indication');

    final searchHint =
        isBangla
            ? 'সার্চ করুন ${widget.filterBy == "Generic" ? "জেনেরিক নাম" : "প্রয়োগ ক্ষেত্র"}'
            : 'Search ${widget.filterBy}';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(isBangla ? Icons.language : Icons.translate),
            tooltip: isBangla ? 'Switch to English' : 'বাংলা দেখান',
            onPressed: () {
              setState(() {
                isBangla = !isBangla;
                loadData();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredItems.isEmpty
                    ? Center(
                      child: Text(
                        isBangla
                            ? 'কোনও ফলাফল পাওয়া যায়নি।'
                            : 'No results found.',
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final value = filteredItems[index];
                        final matched = _getMatchedList(value);

                        return Card(
                          color: const Color.fromARGB(143, 166, 188, 199),
                          child: ListTile(
                            title: Text(value),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => OurMedicinePage(
                                        title: value,
                                        medicineList: matched,
                                        isBangla: isBangla,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
