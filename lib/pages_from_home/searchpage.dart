import 'package:flutter/material.dart';
import 'package:logindemo/models/medicine.dart';
import 'package:logindemo/models/ourmed_da.dart';
import 'package:logindemo/our_medicine/our_details_page.dart';
import 'package:logindemo/provider_and_save/data_provider.dart';
import '../medicine/details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> allMedicines = [];
  List<dynamic> filteredMedicines = [];
  TextEditingController controller = TextEditingController();

  String selectedType = 'Allopathic';
  String selectedLanguage = 'English';
  bool showSuggestions = false;

  final List<String> types = ['Allopathic', 'Our Medicine'];
  final List<String> languages = ['English', 'Bangla'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isBangla = selectedLanguage == 'Bangla';
    List<dynamic> data;

    if (selectedType == 'Our Medicine') {
      data = await DataProvider.loadOurMedicine(bangla: isBangla);
    } else {
      data = await DataProvider.loadAllopathic(bangla: isBangla);
    }

    setState(() {
      allMedicines = data;
      filteredMedicines = data;
      showSuggestions = false;
    });
  }

  void _searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        filteredMedicines = allMedicines;
        showSuggestions = false;
      });
      return;
    }

    List<dynamic> result;

    if (selectedType == 'Our Medicine') {
      result =
          allMedicines.where((med) {
            try {
              final generic = med.genericName.toLowerCase();
              final indication = med.indication.join(', ').toLowerCase();
              return generic.contains(lowerQuery) ||
                  indication.contains(lowerQuery);
            } catch (_) {
              return false;
            }
          }).toList();
    } else {
      result =
          allMedicines.where((med) {
            try {
              final generic = med.genericName.toLowerCase();
              final brand = med.brandName.join(', ').toLowerCase();
              return generic.contains(lowerQuery) || brand.contains(lowerQuery);
            } catch (_) {
              return false;
            }
          }).toList();
    }

    setState(() {
      filteredMedicines = result;
      showSuggestions = true;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 53, 126, 171),
      title: const Text('Search Medicines'),
      actions: [
        DropdownButton<String>(
          value: selectedType,
          dropdownColor: Colors.white,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items:
              types
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedType = value;
                controller.clear();
              });
              _loadData();
            }
          },
        ),
        DropdownButton<String>(
          value: selectedLanguage,
          dropdownColor: Colors.white,
          underline: const SizedBox(),
          icon: const Icon(Icons.language, color: Colors.white),
          items:
              languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedLanguage = value;
                controller.clear();
              });
              _loadData();
            }
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 126, 171),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  onChanged: _searchMedicines,
                  decoration: InputDecoration(
                    hintText:
                        selectedType == 'Allopathic'
                            ? 'Search by brand or generic'
                            : 'Search by generic or indication',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (showSuggestions &&
                    controller.text.isNotEmpty &&
                    filteredMedicines.isNotEmpty)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount:
                          filteredMedicines.length > 5
                              ? 5
                              : filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final med = filteredMedicines[index];
                        final text =
                            selectedType == 'Allopathic'
                                ? (med as FullMed).brandName.join(', ')
                                : (med as OurMedicine).genericName;

                        return ListTile(
                          title: Text(text),
                          onTap: () {
                            controller.text = text;
                            FocusScope.of(context).unfocus();
                            setState(() => showSuggestions = false);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        selectedType == 'Allopathic'
                                            ? DetailsPage(
                                              medicine: med,
                                              isBangla:
                                                  selectedLanguage == 'Bangla',
                                            )
                                            : OurDetailsPage(
                                              medicine: med,
                                              isBangla:
                                                  selectedLanguage == 'Bangla',
                                            ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child:
                filteredMedicines.isEmpty
                    ? const Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final med = filteredMedicines[index];
                        final isOur = selectedType == 'Our Medicine';

                        return Card(
                          color: const Color.fromARGB(231, 180, 212, 231),
                          child: ListTile(
                            title: Text(
                              isOur
                                  ? (med as OurMedicine).genericName
                                  : (med as FullMed).brandName.join(', '),
                            ),
                            subtitle: Text(
                              isOur
                                  ? 'Indications: ${med.indication.join(', ')}'
                                  : 'Generic: ${med.genericName}\n${med.strength} • ${med.dosageDescription}',
                            ),
                            trailing:
                                isOur
                                    ? null
                                    : Text('৳ ${(med as FullMed).price}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          isOur
                                              ? OurDetailsPage(
                                                medicine: med,
                                                isBangla:
                                                    selectedLanguage ==
                                                    'Bangla',
                                              )
                                              : DetailsPage(
                                                medicine: med,
                                                isBangla:
                                                    selectedLanguage ==
                                                    'Bangla',
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
