import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';

/// Değer analizi bölümü widget'ı - iOS tarzı kilitli içerik
class ValueSectionWidget extends StatelessWidget {
  final ScanResultModel? data;

  const ValueSectionWidget({super.key, this.data});

  // Güvenli sayı formatlayıcı: metinden sayıyı yakala, parse edemezse orijinalini döndür
  String _formatNumericString(String? source, NumberFormat fmt) {
    if (source == null || source.trim().isEmpty) return '—';
    final String cleaned = source.replaceAll(RegExp(r'[^0-9,\.]'), '');
    // Önce Avrupa formatını dene: 1.234,56 -> 1234.56
    try {
      final double value = double.parse(
        cleaned.replaceAll('.', '').replaceAll(',', '.'),
      );
      return fmt.format(value);
    } catch (_) {}
    // Sonra US formatını dene: 1,234.56 -> 1234.56
    try {
      final double value = double.parse(cleaned.replaceAll(',', ''));
      return fmt.format(value);
    } catch (_) {}
    // Olmadıysa orijinal metni göster
    return source;
  }

  @override
  Widget build(BuildContext context) {
    final ScanResultModel? data = this.data;
    if (data == null) return const SizedBox.shrink();

    // Test kilidi bayrağı kapalı
    const bool forceUnlockForTest = false; // PROD

    // Premium kontrolü - bu kısım premium kullanıcılar için
    final bool isPremium =
        forceUnlockForTest ||
        (GetStorage().read(MyHelper.isAccountPremium) ?? false);

    // Sayı formatlayıcıyı locale'e göre hazırla
    final String locale = Get.locale?.toLanguageTag() ?? 'tr_TR';
    final NumberFormat numFmt = NumberFormat.decimalPattern(locale);

    // Verileri hazırla (güvenli formatlama)
    final String raw = _formatNumericString(data.rawValuePerKg, numFmt);
    final String processed = _formatNumericString(
      data.processedValuePerCarat,
      numFmt,
    );
    final String collector = _formatNumericString(
      data.collectorMarketValue,
      numFmt,
    );
    final String year = data.marketReferenceYear ?? '2024';
    final String rarity = '${data.rarityScore ?? 7}/10';
    final String perCarat =
        data.valuePerCarat != null ? numFmt.format(data.valuePerCarat) : '—';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPremium) ...[
            _buildModernValueCard(
              raw: raw,
              processed: processed,
              collector: collector,
              year: year,
              rarity: rarity,
              perCarat: perCarat,
            ),
            const SizedBox(height: 12),
            _buildDisclaimerNote(),
          ] else ...[
            _buildLockedValueSection(),
          ],
        ],
      ),
    );
  }

  // Beyaz premium kart (glass yerine) - altın/bej border ve hafif gölge
  Widget _plainCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  // Modern, tek sütun statik KPI kartı
  Widget _buildModernValueCard({
    required String raw,
    required String processed,
    required String collector,
    required String year,
    required String rarity,
    required String perCarat,
  }) {
    const Color darkGold = Color(0xFFB8860B);

    return _plainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D7C3).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 18,
                  color: darkGold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Değer Analizi',
                style: TextStyle(
                  color: AppThemeConfig.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const Spacer(),
              _RarityPill(text: rarity),
            ],
          ),
          const SizedBox(height: 14),
          // Tek sütun: alt alta liste
          _KpiTile(
            icon: Icons.trending_up,
            label: 'Ham Değer (kg)',
            value: raw,
            highlight: true,
          ),
          const SizedBox(height: 12),
          _KpiTile(
            icon: Icons.diamond_outlined,
            label: 'İşlenmiş Değer (karat)',
            value: processed,
          ),
          const SizedBox(height: 12),
          _KpiTile(
            icon: Icons.star_outline,
            label: 'Koleksiyoncu Piyasa Değeri',
            value: collector,
            highlight: true,
          ),
          const SizedBox(height: 12),
          _KpiTile(
            icon: Icons.calendar_month,
            label: 'Piyasa Referans Yılı',
            value: year,
          ),
          const SizedBox(height: 12),
          _KpiTile(
            icon: Icons.attach_money,
            label: 'Değer (ct)',
            value: perCarat,
            highlight: true,
          ),
        ],
      ),
    );
  }

  // Uyarı notu: Değer verileri kesin değildir
  Widget _buildDisclaimerNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE082), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE082),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.info_outline,
              size: 16,
              color: Color(0xFF8D6E63),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Bu bölümdeki değer verileri kestirime dayalıdır ve kesin değildir. Kesin tanı ve değerleme için bir taş analizi uzmanına danışmanız önerilir.',
              style: TextStyle(
                color: Color(0xFF5D4037),
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Kilitli değer bölümü - premium olmayan kullanıcılar için (aktif)
  Widget _buildLockedValueSection() {
    return _plainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D7C3).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 18,
                  color: Color(0xFFB8860B),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Değer Analizi (Kilitli)',
                style: TextStyle(
                  color: AppThemeConfig.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Maskeleme: gri bloklarla örnek satırlar
          ...List.generate(5, (i) => i).map((_) => _skeletonRow()),
          const SizedBox(height: 14),
          // CTA: Kilidi Aç
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 2,
              ),
              onPressed: () => Get.toNamed('/premium'),
              icon: const Icon(Icons.lock_open, size: 18),
              label: const Text(
                'Kilidi Aç',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Basit iskelet satırı
  Widget _skeletonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Kullanım alanları bölümü
}

class _RarityPill extends StatelessWidget {
  final String text;
  const _RarityPill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D7C3).withOpacity(0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Color(0xFFB8860B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppThemeConfig.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  const _KpiTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFF8F6F0) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6D7C3).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE6D7C3), width: 1),
                ),
                child: Icon(icon, size: 14, color: const Color(0xFFB8860B)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppThemeConfig.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
