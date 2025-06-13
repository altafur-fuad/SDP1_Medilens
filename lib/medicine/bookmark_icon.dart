import 'package:flutter/material.dart';
import 'package:logindemo/models/medicine.dart';
import 'package:logindemo/provider_and_save/saved_medicines.dart';

class BookmarkIcon extends StatefulWidget {
  final FullMed medicine;

  const BookmarkIcon({super.key, required this.medicine});

  @override
  State<BookmarkIcon> createState() => _BookmarkIconState();
}

class _BookmarkIconState extends State<BookmarkIcon> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    isSaved = SavedMedicines.isSaved(widget.medicine);
    SavedMedicines.updateNotifier.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        isSaved = SavedMedicines.isSaved(widget.medicine);
      });
    }
  }

  @override
  void dispose() {
    SavedMedicines.updateNotifier.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: isSaved ? const Color.fromARGB(255, 47, 137, 185) : Colors.black,
      ),
      onPressed: () async {
        await SavedMedicines.toggle(widget.medicine);
      },
    );
  }
}
