// lib/provider_and_save/saved_medicines.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medicine.dart';

class SavedMedicines {
  static final List<FullMed> _savedList = [];

  static var updateNotifier;

  static List<FullMed> get savedList => _savedList;

  static Future<void> loadSavedMedicinesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookmarks')
            .get();

    _savedList.clear();
    for (var doc in snapshot.docs) {
      _savedList.add(FullMed.fromJson(doc.data()));
    }
  }

  static Future<void> add(FullMed med) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (!_savedList.any((m) => m.genericName == med.genericName)) {
      _savedList.add(med);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(med.genericName)
          .set(med.toJson());
    }
  }

  static Future<void> remove(FullMed med) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _savedList.removeWhere((m) => m.genericName == med.genericName);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(med.genericName)
        .delete();
  }

  static bool isSaved(FullMed med) {
    return _savedList.any((m) => m.genericName == med.genericName);
  }

  static toggle(FullMed medicine) {}
}
