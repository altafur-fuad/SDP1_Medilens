class OurMedicine {
  final int id;
  final String genericName;
  final List<String> brandName;
  final List<String> indication;
  final bool herbal;
  final bool animalUse;
  final String dosageDescription;
  final List<String> sideEffects;
  final List<String> herbalIngredients;
  final List<String> chemicals;
  final String pharmaceutica;

  OurMedicine({
    required this.id,
    required this.genericName,
    required this.brandName,
    required this.indication,
    required this.herbal,
    required this.animalUse,
    required this.dosageDescription,
    required this.sideEffects,
    required this.herbalIngredients,
    required this.chemicals,
    required this.pharmaceutica,
  });

  factory OurMedicine.fromJson(Map<String, dynamic> json) {
    return OurMedicine(
      id: json['id'] ?? 0,
      genericName: json['genericName'] ?? json['সাধারণ নাম'] ?? '',
      brandName: List<String>.from(
        json['brandName'] ?? json['ব্র্যান্ড নাম'] ?? [],
      ),
      indication: List<String>.from(
        json['indication'] ?? json['প্রয়োগ ক্ষেত্র'] ?? [],
      ),
      herbal: json['herbal'] ?? json['হারবাল'] ?? false,
      animalUse: json['animal_use'] ?? json['প্রাণী ব্যবহৃত'] ?? false,
      dosageDescription: json['dosageDescription'] ?? json['ডোজ বিবরণ'] ?? '',
      sideEffects: List<String>.from(
        json['sideEffects'] ?? json['পার্শ্বপ্রতিক্রিয়া'] ?? [],
      ),
      herbalIngredients: List<String>.from(
        json['herbalIngredients'] ?? json['হারবাল উপাদান'] ?? [],
      ),
      chemicals: List<String>.from(
        json['chemicals'] ?? json['রাসায়নিক উপাদান'] ?? [],
      ),
      pharmaceutica: json['pharmaceutica'] ?? json['ফার্মাসিউটিক্যাল'] ?? '',
    );
  }
}
