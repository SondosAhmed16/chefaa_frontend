class DoctorModel {
  final String id;
  final String userId;
  final String specialization;
  final int? age;
  final int? yearsOfExperience;
  final String contactNumber;
  final String image;
  final String about;
  final String membershipPdf;
  final List<String> degrees;
  final List<String> clinics;
  final String paymentOption;
  final List<String> prePaymentNumbers;
  final double rating;
  final String? gender;
  final double clinicConsultationPrice;
  final List<String> reviews;
  final String visibilityStatus;
  final DateTime? hiddenAt;
  final String? hiddenReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  DoctorModel({
    required this.id,
    required this.userId,
    required this.specialization,
    this.age,
    this.yearsOfExperience,
    this.contactNumber = '',
    this.image = '',
    this.about = '',
    required this.membershipPdf,
    this.degrees = const [],
    this.clinics = const [],
    this.paymentOption = 'in_clinic',
    this.prePaymentNumbers = const [],
    this.rating = 0.0,
    this.gender,
    this.clinicConsultationPrice = 0.0,
    this.reviews = const [],
    this.visibilityStatus = 'active',
    this.hiddenAt,
    this.hiddenReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      userId: json['userId'] is Map
          ? json['userId']['_id']
          : (json['userId'] ?? ''),
      specialization: json['specialization'] ?? '',
      age: json['age'],
      yearsOfExperience: json['yearsOfExperience'],
      contactNumber: json['contactNumber'] ?? '',
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      membershipPdf: json['membershipPdf'] ?? '',
      degrees: List<String>.from(json['degrees'] ?? []),
      clinics: List<String>.from(json['clinics'] ?? []),
      paymentOption: json['paymentOption'] ?? 'in_clinic',
      prePaymentNumbers: List<String>.from(json['prePaymentNumbers'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      gender: json['gender'],
      clinicConsultationPrice:
          (json['clinicConsultationPrice'] as num?)?.toDouble() ?? 0.0,
      reviews: List<String>.from(json['reviews'] ?? []),
      visibilityStatus: json['visibilityStatus'] ?? 'active',
      hiddenAt: json['hiddenAt'] != null
          ? DateTime.tryParse(json['hiddenAt'])
          : null,
      hiddenReason: json['hiddenReason'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'specialization': specialization,
      if (age != null) 'age': age,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      'contactNumber': contactNumber,
      'image': image,
      'about': about,
      'membershipPdf': membershipPdf,
      'degrees': degrees,
      'clinics': clinics,
      'paymentOption': paymentOption,
      'prePaymentNumbers': prePaymentNumbers,
      'rating': rating,
      if (gender != null) 'gender': gender,
      'clinicConsultationPrice': clinicConsultationPrice,
      'reviews': reviews,
      'visibilityStatus': visibilityStatus,
      'hiddenAt': hiddenAt?.toIso8601String(),
      'hiddenReason': hiddenReason,
    };
  }
}
