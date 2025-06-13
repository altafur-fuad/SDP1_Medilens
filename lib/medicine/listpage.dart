import 'package:flutter/material.dart';
import 'package:logindemo/provider_and_save/data_provider.dart';
import '../models/medicine.dart';
import 'medicine_page.dart';

class ListPage extends StatefulWidget {
  final String type; // "Generic", "Brand", "Herbal"

  const ListPage({super.key, required this.type});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> allData = [];
  List<String> allItems = [];
  List<String> filteredItems = [];
  bool isBangla = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (widget.type == 'Herbal') {
      allData = await DataProvider.loadHerbal();
    } else {
      allData = await DataProvider.loadAllopathic(bangla: isBangla);
    }

    allItems.clear();
    if (widget.type == 'Brand') {
      for (var med in allData) {
        allItems.addAll(
          (med as FullMed).brandName.where((name) => name.isNotEmpty),
        );
      }
    } else {
      allItems =
          allData
              .map((e) => (e as FullMed).genericName)
              .where((name) => name.isNotEmpty)
              .toSet()
              .toList();
    }

    setState(() {
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

  List<FullMed> _getMatchedList(String name) {
    return allData
        .where((e) {
          if (e is FullMed) {
            return widget.type == 'Brand'
                ? e.brandName.contains(name)
                : e.genericName == name;
          }
          return false;
        })
        .cast<FullMed>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 206, 222),
      appBar: AppBar(
        title: Text('${widget.type} List (${isBangla ? "বাংলা" : "English"})'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(isBangla ? Icons.language : Icons.translate),
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
                hintText: 'Search ${widget.type}',
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
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final name = filteredItems[index];
                        final matchedList = _getMatchedList(name);

                        return Card(
                          color: const Color.fromARGB(143, 166, 188, 199),
                          child: ListTile(
                            title: Text(name),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => MedicinePage(
                                        medicineList: matchedList,
                                        title: name,
                                        type: widget.type,
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
