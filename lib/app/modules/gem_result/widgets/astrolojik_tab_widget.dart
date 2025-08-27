import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';

/// Astrolojik tab widget'ı
class AstrolojikTabWidget extends StatelessWidget {
  final ScanResultModel data;

  const AstrolojikTabWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Astrolojik anlamlar
          if (data.astrologicalMythologicalMeaning != null &&
              data.astrologicalMythologicalMeaning.toString().isNotEmpty)
            _buildAstrolojikSectionTitle(
              'Astrolojik Anlamlar',
              Icons.auto_awesome,
            ),
          if (data.astrologicalMythologicalMeaning != null &&
              data.astrologicalMythologicalMeaning.toString().isNotEmpty)
            _buildAstrolojikInfoSection([
              data.astrologicalMythologicalMeaning.toString(),
            ]),
          if (data.astrologicalMythologicalMeaning != null &&
              data.astrologicalMythologicalMeaning.toString().isNotEmpty)
            const SizedBox(height: 16),

          // Kültürel önem
          if (data.culturalSignificance != null &&
              data.culturalSignificance.toString().isNotEmpty)
            _buildAstrolojikSectionTitle('Kültürel Önem', Icons.history_edu),
          if (data.culturalSignificance != null &&
              data.culturalSignificance.toString().isNotEmpty)
            _buildAstrolojikInfoSection([data.culturalSignificance.toString()]),
          if (data.culturalSignificance != null &&
              data.culturalSignificance.toString().isNotEmpty)
            const SizedBox(height: 16),

          // Yasal kısıtlamalar
          if (data.legalRestrictions != null &&
              data.legalRestrictions!.isNotEmpty)
            _buildAstrolojikSectionTitle('Yasal Kısıtlamalar', Icons.gavel),
          if (data.legalRestrictions != null &&
              data.legalRestrictions!.isNotEmpty)
            _buildLegalRestrictionsSection(data),
          if (data.legalRestrictions != null &&
              data.legalRestrictions!.isNotEmpty)
            const SizedBox(height: 16),

          // Benzer taşlar
          if (data.similarStones != null && data.similarStones!.isNotEmpty)
            _buildAstrolojikSectionTitle('Benzer Taşlar', Icons.compare_arrows),
          if (data.similarStones != null && data.similarStones!.isNotEmpty)
            _buildSimilarStonesSection(data),
        ],
      ),
    );
  }

  /// Astrolojik bölüm başlığı
  Widget _buildAstrolojikSectionTitle(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFB8860B), // Koyu altın renk
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF2F2F2F), // Koyu gri
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE6D7C3), // Altın/bej renk
                  const Color(0xFFE6D7C3).withOpacity(0.3), // Hafif altın
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Astrolojik bilgi bölümü
  Widget _buildAstrolojikInfoSection(List<dynamic> items) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 13.5,
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  /// Yasal kısıtlamalar bölümü
  Widget _buildLegalRestrictionsSection(ScanResultModel result) {
    final restrictions = _normalizeLegalRestrictionsField(
      result.legalRestrictions,
    );
    if (restrictions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            restrictions
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 13.5,
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  /// Benzer taşlar bölümü
  Widget _buildSimilarStonesSection(ScanResultModel result) {
    final similarStones = _normalizeSimilarStonesField(result.similarStones);
    if (similarStones.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            similarStones
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      item.toString(),
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 13.5,
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  // Helper metodlar

  List<dynamic> _normalizeLegalRestrictionsField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }

  List<dynamic> _normalizeSimilarStonesField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }
}
