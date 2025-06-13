class FullMed {
  final String brandNameRaw;
  final String genericName;
  final String strength;
  final String dosageDescription;
  final String price;
  final String manufacturer;
  final String dar;

  FullMed({
    required this.brandNameRaw,
    required this.genericName,
    required this.strength,
    required this.dosageDescription,
    required this.price,
    required this.manufacturer,
    required this.dar,
  });

  List<String> get brandName =>
      brandNameRaw.split(RegExp(r',\\s*')).where((b) => b.isNotEmpty).toList();

  factory FullMed.fromJson(Map<String, dynamic> json) {
    return FullMed(
      brandNameRaw: json['Brand Name'] ?? json['ব্র্যান্ড নাম'] ?? '',
      genericName: json['Generic Name'] ?? json['জেনেরিক নাম'] ?? '',
      strength: json['Strength'] ?? json['ক্ষমতা'] ?? '',
      dosageDescription: json['Dosage Description'] ?? json['ডোজ বিবরণ'] ?? '',
      price: json['Reatil Price(TK.)'] ?? json['মূল্য (টাকা)'] ?? '',
      manufacturer:
          json['Name of the Pharmaceutical'] ??
          json['ফার্মাসিউটিক্যাল কোম্পানি'] ??
          '',
      dar: json['DAR'] ?? json['ডিএআর নম্বর'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Brand Name': brandNameRaw,
      'Generic Name': genericName,
      'Strength': strength,
      'Dosage Description': dosageDescription,
      'Reatil Price(TK.)': price,
      'Name of the Pharmaceutical': manufacturer,
      'DAR': dar,
    };
  }
}
