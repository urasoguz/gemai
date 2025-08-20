class ScanResultModel {
  // Temel bilgiler
  final String? imagePath;
  final DateTime? createdAt;
  final bool isFavorite; // Favori durumu

  // Gem basic info
  final String? type;
  final String? chemicalFormula;
  final int? mohsHardness;
  final String? colorSpectrum;
  final String? description;

  // Value analysis
  final String? rawValuePerKg;
  final String? processedValuePerCarat;
  final String? collectorMarketValue;
  final String? marketReferenceYear;

  // Scientific verification
  final int? rarityScore;
  final List<String>? possibleFakeIndicators;
  final String? crystalSystem;
  final String? estimatedRefractiveIndex;

  // Commercial collector info
  final List<String>? foundRegions;
  final String? imitationWarning;
  final int? processingDifficulty;

  // Safety legal info
  final String? radioactivity;
  final List<String>? legalRestrictions;
  final List<String>? cleaningMaintenanceTips;

  // Visual properties
  final String? transparency;
  final String? luster;
  final String? inclusions;

  // Additional tools
  final List<String>? similarStones;
  final String? astrologicalMythologicalMeaning;

  // Sistem bilgileri
  final OptimizationInfo? optimizationInfo;
  final ReferenceModel? reference;

  ScanResultModel({
    this.imagePath,
    this.createdAt,
    this.isFavorite = false, // Varsayılan olarak favori değil
    // Gem basic info
    this.type,
    this.chemicalFormula,
    this.mohsHardness,
    this.colorSpectrum,
    this.description,
    // Value analysis
    this.rawValuePerKg,
    this.processedValuePerCarat,
    this.collectorMarketValue,
    this.marketReferenceYear,
    // Scientific verification
    this.rarityScore,
    this.possibleFakeIndicators,
    this.crystalSystem,
    this.estimatedRefractiveIndex,
    // Commercial collector info
    this.foundRegions,
    this.imitationWarning,
    this.processingDifficulty,
    // Safety legal info
    this.radioactivity,
    this.legalRestrictions,
    this.cleaningMaintenanceTips,
    // Visual properties
    this.transparency,
    this.luster,
    this.inclusions,
    // Additional tools
    this.similarStones,
    this.astrologicalMythologicalMeaning,
    // Sistem bilgileri
    this.optimizationInfo,
    this.reference,
  });

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    final reference =
        map['reference'] != null
            ? ReferenceModel.fromMap(map['reference'])
            : null;

    return ScanResultModel(
      imagePath: map['imagePath'] as String?,
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      isFavorite: map['isFavorite'] as bool? ?? false, // Favori durumu
      // Gem basic info
      type: map['type'] as String?,
      chemicalFormula: map['chemical_formula'] as String?,
      mohsHardness: map['mohs_hardness'] as int?,
      colorSpectrum: map['color_spectrum'] as String?,
      description: map['description'] as String?,
      // Value analysis
      rawValuePerKg: map['raw_value_per_kg'] as String?,
      processedValuePerCarat: map['processed_value_per_carat'] as String?,
      collectorMarketValue: map['collector_market_value'] as String?,
      marketReferenceYear: map['market_reference_year'] as String?,
      // Scientific verification
      rarityScore: map['rarity_score'] as int?,
      possibleFakeIndicators:
          (map['possible_fake_indicators'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      crystalSystem: map['crystal_system'] as String?,
      estimatedRefractiveIndex: map['estimated_refractive_index'] as String?,
      // Commercial collector info
      foundRegions:
          (map['found_regions'] as List?)?.map((e) => e.toString()).toList(),
      imitationWarning: map['imitation_warning'] as String?,
      processingDifficulty: map['processing_difficulty'] as int?,
      // Safety legal info
      radioactivity: map['radioactivity'] as String?,
      legalRestrictions:
          (map['legal_restrictions'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      cleaningMaintenanceTips:
          (map['cleaning_maintenance_tips'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      // Visual properties
      transparency: map['transparency'] as String?,
      luster: map['luster'] as String?,
      inclusions: map['inclusions'] as String?,
      // Additional tools
      similarStones:
          (map['similar_stones'] as List?)?.map((e) => e.toString()).toList(),
      astrologicalMythologicalMeaning:
          map['astrological_mythological_meaning'] as String?,
      // Sistem bilgileri
      optimizationInfo:
          map['optimization_info'] != null
              ? OptimizationInfo.fromMap(map['optimization_info'])
              : null,
      reference: reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'createdAt': createdAt?.toIso8601String(),
      'isFavorite': isFavorite, // Favori durumu
      // Gem basic info
      'type': type,
      'chemical_formula': chemicalFormula,
      'mohs_hardness': mohsHardness,
      'color_spectrum': colorSpectrum,
      'description': description,
      // Value analysis
      'raw_value_per_kg': rawValuePerKg,
      'processed_value_per_carat': processedValuePerCarat,
      'collector_market_value': collectorMarketValue,
      'market_reference_year': marketReferenceYear,
      // Scientific verification
      'rarity_score': rarityScore,
      'possible_fake_indicators': possibleFakeIndicators,
      'crystal_system': crystalSystem,
      'estimated_refractive_index': estimatedRefractiveIndex,
      // Commercial collector info
      'found_regions': foundRegions,
      'imitation_warning': imitationWarning,
      'processing_difficulty': processingDifficulty,
      // Safety legal info
      'radioactivity': radioactivity,
      'legal_restrictions': legalRestrictions,
      'cleaning_maintenance_tips': cleaningMaintenanceTips,
      // Visual properties
      'transparency': transparency,
      'luster': luster,
      'inclusions': inclusions,
      // Additional tools
      'similar_stones': similarStones,
      'astrological_mythological_meaning': astrologicalMythologicalMeaning,
      // Sistem bilgileri
      'optimization_info': optimizationInfo?.toMap(),
      'reference': reference?.toMap(),
    };
  }

  /// Favori durumunu değiştir
  ScanResultModel toggleFavorite() {
    return ScanResultModel(
      imagePath: imagePath,
      createdAt: createdAt,
      isFavorite: !isFavorite, // Favori durumunu tersine çevir
      // Gem basic info
      type: type,
      chemicalFormula: chemicalFormula,
      mohsHardness: mohsHardness,
      colorSpectrum: colorSpectrum,
      description: description,
      // Value analysis
      rawValuePerKg: rawValuePerKg,
      processedValuePerCarat: processedValuePerCarat,
      collectorMarketValue: collectorMarketValue,
      marketReferenceYear: marketReferenceYear,
      // Scientific verification
      rarityScore: rarityScore,
      possibleFakeIndicators: possibleFakeIndicators,
      crystalSystem: crystalSystem,
      estimatedRefractiveIndex: estimatedRefractiveIndex,
      // Commercial collector info
      foundRegions: foundRegions,
      imitationWarning: imitationWarning,
      processingDifficulty: processingDifficulty,
      // Safety legal info
      radioactivity: radioactivity,
      legalRestrictions: legalRestrictions,
      cleaningMaintenanceTips: cleaningMaintenanceTips,
      // Visual properties
      transparency: transparency,
      luster: luster,
      inclusions: inclusions,
      // Additional tools
      similarStones: similarStones,
      astrologicalMythologicalMeaning: astrologicalMythologicalMeaning,
      // Sistem bilgileri
      optimizationInfo: optimizationInfo,
      reference: reference,
    );
  }
}

/// Referans bilgileri için model
class ReferenceModel {
  final String label;
  final String url;

  ReferenceModel({required this.label, required this.url});

  factory ReferenceModel.fromMap(Map<String, dynamic> map) {
    return ReferenceModel(
      label: map['label'] as String? ?? '',
      url: map['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'url': url};
  }
}

/// Optimizasyon bilgileri için model
class OptimizationInfo {
  final bool applied;
  final double compressionRatio;
  final int bytesSaved;

  OptimizationInfo({
    required this.applied,
    required this.compressionRatio,
    required this.bytesSaved,
  });

  factory OptimizationInfo.fromMap(Map<String, dynamic> map) {
    return OptimizationInfo(
      applied: map['applied'] as bool? ?? false,
      compressionRatio: (map['compression_ratio'] as num?)?.toDouble() ?? 0.0,
      bytesSaved: map['bytes_saved'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applied': applied,
      'compression_ratio': compressionRatio,
      'bytes_saved': bytesSaved,
    };
  }
}
