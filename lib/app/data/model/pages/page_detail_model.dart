/// Sayfa detay modeli
class PageDetailModel {
  final int id;
  final String slug;
  final String title;
  final String description;
  final bool isActive;
  final int sortOrder;

  PageDetailModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.isActive,
    required this.sortOrder,
  });

  factory PageDetailModel.fromJson(Map<String, dynamic> json) {
    return PageDetailModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }
}

/// Sayfa detay çeviri modeli
class PageDetailTranslationModel {
  final String language;
  final String title;
  final String content;
  final String metaDescription;

  PageDetailTranslationModel({
    required this.language,
    required this.title,
    required this.content,
    required this.metaDescription,
  });

  factory PageDetailTranslationModel.fromJson(Map<String, dynamic> json) {
    return PageDetailTranslationModel(
      language: json['language'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      metaDescription: json['meta_description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'title': title,
      'content': content,
      'meta_description': metaDescription,
    };
  }
}

/// Sayfa detay response modeli
class PageDetailResponseModel {
  final bool success;
  final PageDetailDataModel data;

  PageDetailResponseModel({required this.success, required this.data});

  factory PageDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return PageDetailResponseModel(
      success: json['success'] ?? false,
      data: PageDetailDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.toJson()};
  }
}

/// Sayfa detay data modeli
class PageDetailDataModel {
  final PageDetailModel page;
  final PageDetailTranslationModel translation;

  PageDetailDataModel({required this.page, required this.translation});

  factory PageDetailDataModel.fromJson(Map<String, dynamic> json) {
    return PageDetailDataModel(
      page: PageDetailModel.fromJson(json['page'] ?? {}),
      translation: PageDetailTranslationModel.fromJson(
        json['translation'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page.toJson(), 'translation': translation.toJson()};
  }
}
