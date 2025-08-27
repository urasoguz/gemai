// lib/app/data/model/gem_analysis/gem_analysis_request_model.dart
// Gem analysis API isteği modeli
//
// KULLANIM ÖRNEĞİ:
// ```dart
// final request = GemAnalysisRequestModel(
//   imageBase64: 'base64_encoded_image_string',
//   language: 'Türkçe', // getLanguageName() ile alınır
// );
// ```

/// Gem analysis API isteği modeli
/// Sadece fotoğraf ve dil bilgisi gerekli
class GemAnalysisRequestModel {
  final String imageBase64;
  final String language;

  GemAnalysisRequestModel({required this.imageBase64, required this.language});

  /// JSON'a dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'image': imageBase64,
      'language': language, // "Türkçe", "English", "中文" formatında
      'prompt_key': "gemai",
    };
  }

  /// Model'den kopya oluşturur
  GemAnalysisRequestModel copyWith({String? imageBase64, String? language}) {
    return GemAnalysisRequestModel(
      imageBase64: imageBase64 ?? this.imageBase64,
      language: language ?? this.language,
    );
  }

  @override
  String toString() {
    return 'GemAnalysisRequestModel{imageBase64: $imageBase64, language: $language}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GemAnalysisRequestModel &&
        other.imageBase64 == imageBase64 &&
        other.language == language;
  }

  @override
  int get hashCode {
    return imageBase64.hashCode ^ language.hashCode;
  }
}
