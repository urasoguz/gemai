import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';

/// Temel bilgiler bölümü widget'ı - iOS tarzı minimalist tasarım
class BasicsSectionWidget extends StatelessWidget {
  final ScanResultModel? data;

  const BasicsSectionWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(),
          const SizedBox(height: 12),
          // Taş adı (type) - açıklamanın üstünde gösterilir
          if (data?.type != null && data!.type!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppThemeConfig.divider.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                data!.type!,
                style: TextStyle(
                  color: AppThemeConfig.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (data?.type != null && data!.type!.isNotEmpty)
            const SizedBox(height: 12),
          _buildDescriptionSection(data?.description),
          const SizedBox(height: 16),
          // Değer analizi kaldırıldı - fiyat tab'ında zaten var
          // ValueSectionWidget(data: data),
          const SizedBox(height: 16),
          // Önemli bilgiler kaldırıldı - kimyasal tab'da Fiziksel Özellikler olarak var
          // _buildImportantInfoSection(),
          // const SizedBox(height: 16),
          // Fiziksel özellikler kaldırıldı - kimyasal tab'ına taşındı
          // _buildExtendedPropertiesSection(),
          // const SizedBox(height: 16),
          // Renk spektrumu kaldırıldı - kimyasal tab'ına taşındı
          // _buildColorSpectrumSection(),
          // const SizedBox(height: 12),
          _buildFoundRegionsSection(),
          const SizedBox(height: 12),
          // Sahte taş belirtileri kaldırıldı - kimyasal tab'ına taşındı
          // _buildFakeIndicatorsSection(),
          // const SizedBox(height: 12),
          // Taklit uyarısı kaldırıldı - kimyasal tab'ına taşındı
          // _buildImitationWarningSection(),
          const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFFB8860B), // Koyu altın renk
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Temel Bilgiler',
                style: TextStyle(
                  color: const Color(0xFF2F2F2F), // Koyu gri
                  fontSize: 18,
                  fontWeight: FontWeight.w700, // Daha kalın
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2, // Daha kalın
            width: 120, // Daha uzun
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

  Widget _buildDescriptionSection(String? description) {
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppThemeConfig.divider.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        description,
        style: TextStyle(
          color: AppThemeConfig.textPrimary,
          fontSize: 13.5,
          height: 1.5,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildFoundRegionsSection() {
    final regions = data?.foundRegions;
    if (regions == null || !_isValidRegionsField(regions)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubSectionTitle('Bulunduğu Bölgeler', Icons.location_on_outlined),
        Container(
          width: double.infinity, // Tam genişlik
          decoration: BoxDecoration(
            color: Colors.white, // Beyaz arka plan
            borderRadius: BorderRadius.circular(12), // Hafif radius
            border: Border.all(
              color: Colors.grey.withOpacity(0.2), // Hafif gri border
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _normalizeRegionsField(
                  regions,
                ).map((region) => _buildRegionChip(region.toString())).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubSectionTitle(String title, IconData icon) {
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

  Widget _buildRegionChip(String region) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(
          0xFFE6D7C3,
        ).withOpacity(0.3), // Hafif altın arka plan
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB8860B).withOpacity(0.4), // Altın kenarlık
          width: 1,
        ),
      ),
      child: Text(
        region,
        style: TextStyle(
          color: const Color(0xFFB8860B), // Altın metin rengi
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _isValidRegionsField(dynamic value) {
    return value != null && (value is String || value is List);
  }

  List<dynamic> _normalizeRegionsField(dynamic value) {
    if (value is String) {
      return value.split(',').map((s) => s.trim()).toList();
    }
    if (value is List) {
      return value;
    }
    return [];
  }
}
