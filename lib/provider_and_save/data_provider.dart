import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logindemo/models/ourmed_da.dart';
import '../models/medicine.dart';

class DataProvider {
  static Future<List<FullMed>> loadHerbal() async {
    final jsonString = await rootBundle.loadString('assets/data/herbal.json');
    final jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData.map((e) => FullMed.fromJson(e)).toList();
  }

  static Future<List<FullMed>> loadFullDataset() async {
    final allopathic = await loadAllopathic();
    final herbal = await loadHerbal();
    return [...allopathic, ...herbal];
  }

  static Future<List<OurMedicine>> loadOurMedicine({
    bool bangla = false,
  }) async {
    final file =
        bangla
            ? 'assets/data/medicinedataset_bn.json'
            : 'assets/data/medicinedataset.json';
    final jsonString = await rootBundle.loadString(file);
    final jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData.map((e) => OurMedicine.fromJson(e)).toList();
  }

  static Future<List<FullMed>> loadAllopathic({bool bangla = false}) async {
    final file =
        bangla
            ? 'assets/data/allopathic_bn.json'
            : 'assets/data/allopathic.json';
    final jsonString = await rootBundle.loadString(file);
    final jsonData = json.decode(jsonString) as List<dynamic>;
    return jsonData.map((e) => FullMed.fromJson(e)).toList();
  }
}
