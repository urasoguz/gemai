class ScanResultModel {
  final String? name;
  final String? altName;
  final String? description;
  final List<String>? symptoms;
  final List<String>? treatment;
  final String? severityRatio;
  final String? category;
  final String? contagious;
  final List<String>? bodyParts;
  final List<String>? riskFactors;
  final List<String>? prevention;
  final String? recoveryTime;
  final List<String>? alternativeTreatments;
  final String? imagePath;
  final DateTime? createdAt;
  final OptimizationInfo? optimizationInfo;

  ScanResultModel({
    this.name,
    this.altName,
    this.description,
    this.symptoms,
    this.treatment,
    this.severityRatio,
    this.category,
    this.contagious,
    this.bodyParts,
    this.riskFactors,
    this.prevention,
    this.recoveryTime,
    this.alternativeTreatments,
    this.imagePath,
    this.createdAt,
    this.optimizationInfo,
  });

  factory ScanResultModel.fromMap(Map<String, dynamic> map) {
    return ScanResultModel(
      name: map['name'] as String?,
      altName: map['alt_name'] as String?,
      description: map['description'] as String?,
      symptoms: (map['symptoms'] as List?)?.map((e) => e.toString()).toList(),
      treatment: (map['treatment'] as List?)?.map((e) => e.toString()).toList(),
      severityRatio: map['severity_ratio']?.toString(),
      category: map['category'] as String?,
      contagious: map['contagious'] as String?,
      bodyParts:
          (map['body_parts'] as List?)?.map((e) => e.toString()).toList(),
      riskFactors:
          (map['risk_factors'] as List?)?.map((e) => e.toString()).toList(),
      prevention:
          (map['prevention'] as List?)?.map((e) => e.toString()).toList(),
      recoveryTime: map['recovery_time'] as String?,
      alternativeTreatments:
          (map['alternative_treatments'] as List?)
              ?.map((e) => e.toString())
              .toList(),
      imagePath: map['imagePath'] as String?,
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      optimizationInfo:
          map['optimization_info'] != null
              ? OptimizationInfo.fromMap(map['optimization_info'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'alt_name': altName,
      'description': description,
      'symptoms': symptoms,
      'treatment': treatment,
      'severity_ratio': severityRatio,
      'category': category,
      'contagious': contagious,
      'body_parts': bodyParts,
      'risk_factors': riskFactors,
      'prevention': prevention,
      'recovery_time': recoveryTime,
      'alternative_treatments': alternativeTreatments,
      'imagePath': imagePath,
      'createdAt': createdAt?.toIso8601String(),
      'optimization_info': optimizationInfo?.toMap(),
    };
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
