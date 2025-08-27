class ScanResultModel {
  final dynamic id;
  final dynamic imagePath;
  final DateTime? createdAt; // DateTime? olarak geri getirildi
  final dynamic isFavorite;
  final dynamic type;
  final dynamic chemicalFormula;
  final dynamic mohsHardness;
  final dynamic colorSpectrum;
  final dynamic description;
  final dynamic rawValuePerKg;
  final dynamic processedValuePerCarat;
  final dynamic collectorMarketValue;
  final dynamic marketReferenceYear;
  final dynamic valuePerCarat;
  final dynamic rarityScore;
  final dynamic possibleFakeIndicators;
  final dynamic crystalSystem;
  final dynamic estimatedRefractiveIndex;
  final dynamic processingDifficulty;
  final dynamic foundRegions;
  final dynamic imitationWarning;
  final dynamic radioactivity;
  final dynamic legalRestrictions;
  final dynamic cleaningMaintenanceTips;
  final dynamic transparency;
  final dynamic luster;
  final dynamic inclusions;
  final dynamic similarStones;
  final dynamic astrologicalMythologicalMeaning;
  final dynamic extendedColorSpectrum;
  final dynamic magnetism;
  final dynamic tenacity;
  final dynamic cleavage;
  final dynamic fracture;
  final dynamic density;
  final dynamic chemicalClassification;
  final dynamic elements;
  final dynamic commonImpurities;
  final dynamic formation;
  final dynamic ageRange;
  final dynamic ageDescription;
  final dynamic uses;
  final dynamic culturalSignificance;

  ScanResultModel({
    this.id,
    this.imagePath,
    this.createdAt, // required kaldırıldı
    this.isFavorite,
    this.type,
    this.chemicalFormula,
    this.mohsHardness,
    this.colorSpectrum,
    this.description,
    this.rawValuePerKg,
    this.processedValuePerCarat,
    this.collectorMarketValue,
    this.marketReferenceYear,
    this.valuePerCarat,
    this.rarityScore,
    this.possibleFakeIndicators,
    this.crystalSystem,
    this.estimatedRefractiveIndex,
    this.processingDifficulty,
    this.foundRegions,
    this.imitationWarning,
    this.radioactivity,
    this.legalRestrictions,
    this.cleaningMaintenanceTips,
    this.transparency,
    this.luster,
    this.inclusions,
    this.similarStones,
    this.astrologicalMythologicalMeaning,
    this.extendedColorSpectrum,
    this.magnetism,
    this.tenacity,
    this.cleavage,
    this.fracture,
    this.density,
    this.chemicalClassification,
    this.elements,
    this.commonImpurities,
    this.formation,
    this.ageRange,
    this.ageDescription,
    this.uses,
    this.culturalSignificance,
  });

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    List<dynamic> asDynamicList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value; // Direkt listeyi döndür
      }
      return [];
    }

    return ScanResultModel(
      id: map['id'],
      imagePath:
          map['imagePath'] ??
          map['image_path'], // Hem imagePath hem de image_path key'lerini kontrol et
      createdAt:
          map['created_at'] != null
              ? DateTime.tryParse(map['created_at'].toString())
              : null, // Eski haline geri getirildi
      isFavorite: map['is_favorite'],
      type: map['type'],
      chemicalFormula: map['chemical_formula'],
      mohsHardness: map['mohs_hardness'],
      colorSpectrum: map['color_spectrum'],
      description: map['description'],
      rawValuePerKg: map['raw_value_per_kg'],
      processedValuePerCarat: map['processed_value_per_carat'],
      collectorMarketValue: map['collector_market_value'],
      marketReferenceYear: map['market_reference_year'],
      valuePerCarat: map['value_per_carat'],
      rarityScore: map['rarity_score'],
      possibleFakeIndicators: asDynamicList(map['possible_fake_indicators']),
      crystalSystem: map['crystal_system'],
      estimatedRefractiveIndex: map['estimated_refractive_index'],
      processingDifficulty: map['processing_difficulty'],
      foundRegions: asDynamicList(map['found_regions']),
      imitationWarning: map['imitation_warning'],
      radioactivity: map['radioactivity'],
      legalRestrictions: asDynamicList(map['legal_restrictions']),
      cleaningMaintenanceTips: asDynamicList(map['cleaning_maintenance_tips']),
      transparency: asDynamicList(map['transparency']),
      luster: asDynamicList(map['luster']),
      inclusions: map['inclusions'],
      similarStones: asDynamicList(map['similar_stones']),
      astrologicalMythologicalMeaning: map['astrological_mythological_meaning'],
      extendedColorSpectrum: asDynamicList(map['extended_color_spectrum']),
      magnetism: map['magnetism'],
      tenacity: map['tenacity'],
      cleavage: map['cleavage'],
      fracture: map['fracture'],
      density: map['density'],
      chemicalClassification: map['chemical_classification'],
      elements: asDynamicList(map['elements']),
      commonImpurities: asDynamicList(map['common_impurities']),
      formation: map['formation'],
      ageRange: map['age_range'],
      ageDescription: map['age_description'],
      uses: map['uses'],
      culturalSignificance: map['cultural_significance'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath, // imagePath key'ini de ekle
      'image_path': imagePath, // Eski key'i de koru
      'created_at':
          createdAt?.toIso8601String(), // DateTime olarak geri getirildi
      'is_favorite': isFavorite,
      'type': type,
      'chemical_formula': chemicalFormula,
      'mohs_hardness': mohsHardness,
      'color_spectrum': colorSpectrum,
      'description': description,
      'raw_value_per_kg': rawValuePerKg,
      'processed_value_per_carat': processedValuePerCarat,
      'collector_market_value': collectorMarketValue,
      'market_reference_year': marketReferenceYear,
      'value_per_carat': valuePerCarat,
      'rarity_score': rarityScore,
      'possible_fake_indicators': possibleFakeIndicators,
      'crystal_system': crystalSystem,
      'estimated_refractive_index': estimatedRefractiveIndex,
      'processing_difficulty': processingDifficulty,
      'found_regions': foundRegions,
      'imitation_warning': imitationWarning,
      'radioactivity': radioactivity,
      'legal_restrictions': legalRestrictions,
      'cleaning_maintenance_tips': cleaningMaintenanceTips,
      'transparency': transparency,
      'luster': luster,
      'inclusions': inclusions,
      'similar_stones': similarStones,
      'astrological_mythological_meaning': astrologicalMythologicalMeaning,
      'extended_color_spectrum': extendedColorSpectrum,
      'magnetism': magnetism,
      'tenacity': tenacity,
      'cleavage': cleavage,
      'fracture': fracture,
      'density': density,
      'chemical_classification': chemicalClassification,
      'elements': elements,
      'common_impurities': commonImpurities,
      'formation': formation,
      'age_range': ageRange,
      'age_description': ageDescription,
      'uses': uses,
      'cultural_significance': culturalSignificance,
    };
  }

  ScanResultModel copyWith({
    dynamic id,
    dynamic imagePath,
    dynamic createdAt,
    dynamic isFavorite,
    dynamic type,
    dynamic chemicalFormula,
    dynamic mohsHardness,
    dynamic colorSpectrum,
    dynamic description,
    dynamic rawValuePerKg,
    dynamic processedValuePerCarat,
    dynamic collectorMarketValue,
    dynamic marketReferenceYear,
    dynamic valuePerCarat,
    dynamic rarityScore,
    dynamic possibleFakeIndicators,
    dynamic crystalSystem,
    dynamic estimatedRefractiveIndex,
    dynamic processingDifficulty,
    dynamic foundRegions,
    dynamic imitationWarning,
    dynamic radioactivity,
    dynamic legalRestrictions,
    dynamic cleaningMaintenanceTips,
    dynamic transparency,
    dynamic luster,
    dynamic inclusions,
    dynamic similarStones,
    dynamic astrologicalMythologicalMeaning,
    dynamic extendedColorSpectrum,
    dynamic magnetism,
    dynamic tenacity,
    dynamic cleavage,
    dynamic fracture,
    dynamic density,
    dynamic chemicalClassification,
    dynamic elements,
    dynamic commonImpurities,
    dynamic formation,
    dynamic ageRange,
    dynamic ageDescription,
    dynamic uses,
    dynamic culturalSignificance,
  }) {
    return ScanResultModel(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      type: type ?? this.type,
      chemicalFormula: chemicalFormula ?? this.chemicalFormula,
      mohsHardness: mohsHardness ?? this.mohsHardness,
      colorSpectrum: colorSpectrum ?? this.colorSpectrum,
      description: description ?? this.description,
      rawValuePerKg: rawValuePerKg ?? this.rawValuePerKg,
      processedValuePerCarat:
          processedValuePerCarat ?? this.processedValuePerCarat,
      collectorMarketValue: collectorMarketValue ?? this.collectorMarketValue,
      marketReferenceYear: marketReferenceYear ?? this.marketReferenceYear,
      valuePerCarat: valuePerCarat ?? this.valuePerCarat,
      rarityScore: rarityScore ?? this.rarityScore,
      possibleFakeIndicators:
          possibleFakeIndicators ?? this.possibleFakeIndicators,
      crystalSystem: crystalSystem ?? this.crystalSystem,
      estimatedRefractiveIndex:
          estimatedRefractiveIndex ?? this.estimatedRefractiveIndex,
      processingDifficulty: processingDifficulty ?? this.processingDifficulty,
      foundRegions: foundRegions ?? this.foundRegions,
      imitationWarning: imitationWarning ?? this.imitationWarning,
      radioactivity: radioactivity ?? this.radioactivity,
      legalRestrictions: legalRestrictions ?? this.legalRestrictions,
      cleaningMaintenanceTips:
          cleaningMaintenanceTips ?? this.cleaningMaintenanceTips,
      transparency: transparency ?? this.transparency,
      luster: luster ?? this.luster,
      inclusions: inclusions ?? this.inclusions,
      similarStones: similarStones ?? this.similarStones,
      astrologicalMythologicalMeaning:
          astrologicalMythologicalMeaning ??
          this.astrologicalMythologicalMeaning,
      extendedColorSpectrum:
          extendedColorSpectrum ?? this.extendedColorSpectrum,
      magnetism: magnetism ?? this.magnetism,
      tenacity: tenacity ?? this.tenacity,
      cleavage: cleavage ?? this.cleavage,
      fracture: fracture ?? this.fracture,
      density: density ?? this.density,
      chemicalClassification:
          chemicalClassification ?? this.chemicalClassification,
      elements: elements ?? this.elements,
      commonImpurities: commonImpurities ?? this.commonImpurities,
      formation: formation ?? this.formation,
      ageRange: ageRange ?? this.ageRange,
      ageDescription: ageDescription ?? this.ageDescription,
      uses: uses ?? this.uses,
      culturalSignificance: culturalSignificance ?? this.culturalSignificance,
    );
  }
}
