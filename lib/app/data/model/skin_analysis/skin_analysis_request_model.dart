// lib/app/data/model/skin_analysis/skin_analysis_request_model.dart
// Cilt analizi API isteği modeli
//
// KULLANIM ÖRNEĞİ:
// ```dart
// final request = SkinAnalysisRequestModel(
//   imageBase64: 'base64_encoded_image_string',
//   age: 25,
//   bodyParts: ['Yüz', 'El'],
//   complaints: 'Kaşıntı ve kızarıklık var',
//   language: 'tr',
// );
// ```

/// Cilt analizi API isteği modeli
class SkinAnalysisRequestModel {
  final String imageBase64;
  final int age;
  final List<String> bodyParts;
  final String complaints;
  final String language;

  SkinAnalysisRequestModel({
    required this.imageBase64,
    required this.age,
    required this.bodyParts,
    required this.complaints,
    required this.language,
  });

  /// JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'image': imageBase64,
      'selectedAge': age.toString(), // Integer'ı string'e çevir
      'selectedRegions': bodyParts,
      'details': complaints,
      'language': language,
    };
  }

  /// Model'den kopya oluşturur
  SkinAnalysisRequestModel copyWith({
    String? imageBase64,
    int? age,
    List<String>? bodyParts,
    String? complaints,
    String? language,
  }) {
    return SkinAnalysisRequestModel(
      imageBase64: imageBase64 ?? this.imageBase64,
      age: age ?? this.age,
      bodyParts: bodyParts ?? this.bodyParts,
      complaints: complaints ?? this.complaints,
      language: language ?? this.language,
    );
  }

  @override
  String toString() {
    return 'SkinAnalysisRequestModel{imageBase64: $imageBase64, age: $age, bodyParts: $bodyParts, complaints: $complaints, language: $language}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkinAnalysisRequestModel &&
        other.imageBase64 == imageBase64 &&
        other.age == age &&
        other.bodyParts == bodyParts &&
        other.complaints == complaints &&
        other.language == language;
  }

  @override
  int get hashCode {
    return imageBase64.hashCode ^
        age.hashCode ^
        bodyParts.hashCode ^
        complaints.hashCode ^
        language.hashCode;
  }
}
