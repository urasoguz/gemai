/// Sayfa çeviri modeli
class PageTranslationModel {
  final String language;
  final String title;
  final String? metaDescription;

  PageTranslationModel({
    required this.language,
    required this.title,
    this.metaDescription,
  });

  factory PageTranslationModel.fromJson(Map<String, dynamic> json) {
    return PageTranslationModel(
      language: json['language'] ?? '',
      title: json['title'] ?? '',
      metaDescription: json['meta_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'title': title,
      'meta_description': metaDescription,
    };
  }
}

/// Sayfa listesi modeli
class PageModel {
  final int id;
  final String slug;
  final String? title;
  final String? description;
  final int sortOrder;
  final PageTranslationModel translation;

  PageModel({
    required this.id,
    required this.slug,
    this.title,
    this.description,
    required this.sortOrder,
    required this.translation,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'],
      description: json['description'],
      sortOrder: json['sort_order'] ?? 0,
      translation: PageTranslationModel.fromJson(json['translation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'sort_order': sortOrder,
      'translation': translation.toJson(),
    };
  }
}

/// Sayfa listesi response modeli
class PagesListResponseModel {
  final bool success;
  final List<PageModel> data;

  PagesListResponseModel({required this.success, required this.data});

  factory PagesListResponseModel.fromJson(Map<String, dynamic> json) {
    return PagesListResponseModel(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => PageModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
