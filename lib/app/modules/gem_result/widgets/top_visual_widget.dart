import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl hide TextDirection;
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/gem_result/controller/gem_result_controller.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/core/theme/app_colors.dart';
import 'package:gemai/app/core/services/date_formatting_service.dart';
import 'dart:ui'; // Added for ImageFilter
import 'package:flutter/foundation.dart'; // Added for kDebugMode
import 'dart:convert'; // Added for base64Decode
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:gemai/app/modules/gem_result/widgets/shareable_gem_result_widget.dart';

/// Üst görsel widget - foto, başlık, butonlar
class TopVisualWidget extends StatefulWidget {
  final GlobalKey shareKey;

  const TopVisualWidget({super.key, required this.shareKey});

  @override
  State<TopVisualWidget> createState() => _TopVisualWidgetState();
}

class _TopVisualWidgetState extends State<TopVisualWidget> {
  // GlobalKey artık widget'tan geliyor

  // Camsı kart sarmalayıcı (parametreli)
  Widget _glassCard({
    required Widget child,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
    double bgOpacity = 0.12,
    Color? borderColor,
    Color? shadowColor,
    double shadowBlur = 14,
    Offset shadowOffset = const Offset(0, 6),
    double borderWidth = 0.8,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppThemeConfig.white.withOpacity(bgOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: (borderColor ?? AppThemeConfig.white.withOpacity(0.28)),
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: (shadowColor ?? AppThemeConfig.black.withOpacity(0.18)),
                blurRadius: shadowBlur,
                offset: shadowOffset,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // Camsı nadirlik rozeti (sade altın vurgulu iOS stil)
  Widget _buildRarityChip(dynamic score) {
    // Etiketleri koruyalım ama renkleri sabitleyelim
    final int s = _normalizeRarityScore(score).clamp(0, 10);
    String label;
    if (s >= 9) {
      label = 'top_visual_rarity_desc_1'.tr;
    } else if (s >= 7) {
      label = 'top_visual_rarity_desc_2'.tr;
    } else if (s >= 4) {
      label = 'top_visual_rarity_desc_3'.tr;
    } else {
      label = 'top_visual_rarity_desc_4'.tr;
    }
    const Color gold = AppThemeConfig.astroGold;
    const Color darkGold = AppThemeConfig.astroTitleIcon;

    return _glassCard(
      bgOpacity: 0.12,
      borderColor: AppThemeConfig.white.withOpacity(0.25),
      shadowColor: AppThemeConfig.black.withOpacity(0.12),
      shadowBlur: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: darkGold.withOpacity(0.35), width: 0.8),
            ),
            child: const Icon(
              Icons.diamond,
              size: 16,
              color: AppThemeConfig.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppThemeConfig.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for rarity score normalization
  int _normalizeRarityScore(dynamic value) {
    if (value == null) return 5;

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    if (value is String) {
      try {
        final doubleValue = double.parse(value);
        return doubleValue.round();
      } catch (e) {
        return 5; // Default değer
      }
    }

    return 5; // Default değer
  }

  // Camsı fiyat rozeti (sade altın vurgulu iOS stil)
  Widget _buildPriceChip(dynamic pricePerCarat) {
    final String valueText = _formatPriceValue(pricePerCarat);
    const Color gold = AppThemeConfig.astroGold;
    const Color darkGold = AppThemeConfig.astroTitleIcon;

    return _glassCard(
      bgOpacity: 0.12,
      borderColor: AppThemeConfig.white.withOpacity(0.25),
      shadowColor: AppThemeConfig.black.withOpacity(0.12),
      shadowBlur: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: gold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: darkGold.withOpacity(0.35), width: 0.8),
            ),
            child: const Icon(
              Icons.attach_money,
              color: AppThemeConfig.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            valueText,
            style: const TextStyle(
              color: AppThemeConfig.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Fiyat formatlama yardımcı metodu
  // Türkçe binlik ayraç (.) kullanarak sayıyı formatlar
  String _formatPriceValue(dynamic value) {
    if (value == null) return '—';
    num? numeric;
    if (value is int)
      numeric = value;
    else if (value is double)
      numeric = value;
    else if (value is String) {
      try {
        numeric = num.parse(value);
      } catch (_) {
        return value; // Parse edilemiyorsa olduğu gibi döndür
      }
    } else {
      return value.toString();
    }

    final intl.NumberFormat formatter = intl.NumberFormat.decimalPattern(
      'tr_TR',
    );
    return formatter.format(numeric.round());
  }

  // Helper method for placeholder image
  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.6),
            AppThemeConfig.accentPurple.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diamond, size: 80, color: Colors.white.withOpacity(0.8)),
            const SizedBox(height: 16),
            Text(
              'top_visual_gem_analysis'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GemResultController>();

    return Container(
      width: double.infinity,
      height:
          MediaQuery.of(context).size.height * 0.37, // Foto alanını küçülttüm
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero, // Üst sol düz
          topRight: Radius.zero, // Üst sağ düz
          bottomLeft: Radius.zero, // Alt sol düz
          bottomRight: Radius.zero, // Alt sağ düz
        ),
        boxShadow: [
          BoxShadow(
            color: AppThemeConfig.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero, // Üst sol düz
          topRight: Radius.zero, // Üst sağ düz
          bottomLeft: Radius.zero, // Alt sol düz
          bottomRight: Radius.zero, // Alt sağ düz
        ),
        child: Stack(
          children: [
            // Ana görsel - base64'ten veya placeholder
            Positioned.fill(
              child: Obx(() {
                final result = controller.result.value;
                if (kDebugMode) {
                  print('🔍 TopVisualWidget - result: ${result?.type}');
                  print(
                    '🔍 TopVisualWidget - imagePath: ${result?.imagePath != null ? "Mevcut (${result!.imagePath!.length} karakter)" : "Yok"}',
                  );
                  if (result?.imagePath != null) {
                    print(
                      '🔍 TopVisualWidget - ImagePath başlangıcı: ${result!.imagePath!.substring(0, 50)}...',
                    );
                  }
                }

                if (result?.imagePath != null &&
                    result!.imagePath!.isNotEmpty) {
                  // Base64 görsel varsa göster
                  if (result.imagePath!.startsWith('data:image')) {
                    try {
                      final base64Str = result.imagePath!.split(',').last;
                      final bytes = base64Decode(base64Str);
                      if (kDebugMode) {
                        print(
                          '🔍 TopVisualWidget - Base64 görsel yüklendi - Boyut: ${bytes.length} bytes',
                        );
                      }
                      return Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          if (kDebugMode) {
                            print(
                              '❌ TopVisualWidget - Base64 görsel yüklenemedi: $error',
                            );
                          }
                          return _buildPlaceholderImage();
                        },
                      );
                    } catch (e) {
                      if (kDebugMode) {
                        print('❌ TopVisualWidget - Base64 decode hatası: $e');
                      }
                      return _buildPlaceholderImage();
                    }
                  } else {
                    // Network görsel varsa göster
                    if (kDebugMode) {
                      print(
                        '🔍 TopVisualWidget - Network görsel yükleniyor: ${result.imagePath}',
                      );
                    }
                    return Image.network(
                      result.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        if (kDebugMode) {
                          print(
                            '❌ TopVisualWidget - Network görsel yüklenemedi: $error',
                          );
                        }
                        return _buildPlaceholderImage();
                      },
                    );
                  }
                } else {
                  // Görsel yoksa placeholder göster
                  if (kDebugMode) {
                    print(
                      '⚠️ TopVisualWidget - Görsel bulunamadı, placeholder gösteriliyor',
                    );
                  }
                  return _buildPlaceholderImage();
                }
              }),
            ),

            // Üst gradient overlay - status bar üzerinde
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100, // Status bar üzerinde
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppThemeConfig.black.withOpacity(0.6),
                      AppThemeConfig.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Alt gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppThemeConfig.black.withOpacity(0.7),
                      AppThemeConfig.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Üst bilgiler - title ve saat
            Positioned(
              top: 50, // Status bar üzerinde
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Geri butonu
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Builder(
                          builder: (context) {
                            final TextDirection dir = Directionality.of(
                              context,
                            );
                            final IconData backIcon =
                                dir == TextDirection.ltr
                                    ? Icons.arrow_back_ios_new
                                    : Icons.arrow_forward_ios;
                            return IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                backIcon,
                                color: Colors.white,
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title - dinamik: modelden gelir, yoksa fallback
                      Expanded(
                        child: Obx(() {
                          final title = controller.result.value?.type;
                          return Text(
                            title != null && title.isNotEmpty
                                ? title
                                : 'top_visual_analysis_title'.tr,
                            style: TextStyle(
                              color: AppThemeConfig.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(
                                    0.8,
                                  ), // Siyah gölge
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Saat alanı - küçülttüm
                  _glassCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    bgOpacity: 0.15,
                    borderColor: Colors.white.withOpacity(0.3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white, // Daha koyu beyaz
                          size: 16, // 20'den 16'ya küçülttüm
                          shadows: [
                            Shadow(
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                              color: AppThemeConfig.black.withOpacity(
                                0.8,
                              ), // Siyah gölge
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        FutureBuilder<String>(
                          future:
                              controller.result.value?.createdAt != null
                                  ? (Get.isRegistered<DateFormattingService>()
                                      ? Get.find<DateFormattingService>()
                                          .formatRelativeDate(
                                            controller.result.value!.createdAt!,
                                          )
                                      : Future.value(
                                        '${controller.result.value!.createdAt!.day}/${controller.result.value!.createdAt!.month}/${controller.result.value!.createdAt!.year}',
                                      ))
                                  : Future.value(''),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return Text(
                                snapshot.data!,
                                style: TextStyle(
                                  color: Colors.white, // Daha koyu beyaz
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600, // Daha kalın
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(
                                        0.8,
                                      ), // Siyah gölge
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              if (kDebugMode) {
                                print(
                                  '❌ TopVisualWidget - Tarih formatlanamadı: ${snapshot.error}',
                                );
                              }
                              // Hata durumunda basit tarih göster
                              if (controller.result.value?.createdAt != null) {
                                final date =
                                    controller.result.value!.createdAt!;
                                return Text(
                                  '${date.day}/${date.month}/${date.year}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(1, 1),
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return Text(
                              '...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Alt bilgiler - nadir ve değer
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Obx(() {
                final rarityScore = controller.result.value?.rarityScore;
                final pricePerCarat = controller.result.value?.valuePerCarat;

                if (kDebugMode) {
                  print('🔍 TopVisualWidget - rarityScore: $rarityScore');
                  print('🔍 TopVisualWidget - pricePerCarat: $pricePerCarat');
                  print(
                    '🔍 TopVisualWidget - processedValuePerCarat: ${controller.result.value?.processedValuePerCarat}',
                  );
                  print(
                    '🔍 TopVisualWidget - rawValuePerKg: ${controller.result.value?.rawValuePerKg}',
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildRarityChip(rarityScore),
                    // Ortadaki favori butonu
                    _glassCard(
                      borderRadius: 22,
                      padding: EdgeInsets.zero,
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          onPressed: () => controller.toggleFavorite(),
                          icon: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                controller.isFavorite.value
                                    ? Colors.red
                                    : Colors.white,
                            size: 22,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    _buildPriceChip(pricePerCarat),
                  ],
                );
              }),
            ),

            // Sağ üst butonlar - normal widget olarak
            Positioned(
              top: 50, // Status bar üzerinde
              right: 20,
              child: Column(
                children: [
                  // Büyüteç butonu
                  _glassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    bgOpacity: 0.25, // Biraz koyulaştırıldı
                    borderColor: Colors.white.withOpacity(0.25),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          // Fotoğrafı büyült
                          final result = controller.result.value;
                          if (result?.imagePath != null &&
                              result!.imagePath!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => _PhotoViewScreen(
                                      imagePath: result.imagePath!,
                                      title:
                                          result.type ??
                                          'top_visual_analysis_image'.tr,
                                    ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Paylaş butonu
                  _glassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.zero,
                    bgOpacity: 0.25, // Biraz koyulaştırıldı
                    borderColor: Colors.white.withOpacity(0.25),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        onPressed: () {
                          final result = controller.result.value;
                          if (result != null) {
                            _shareComposedResult(context, result);
                          }
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Oluşturulmuş birleşik widget üzerinden paylaşım
  Future<void> _shareComposedResult(
    BuildContext context,
    ScanResultModel result,
  ) async {
    try {
      final bytes = await _captureWithSelection(context, result);
      if (bytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('top_visual_picture_error'.tr)),
          );
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/gemai_share.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'top_visual_share_text'.trParams({
          'type': (result.type ?? 'unknown_gem'.tr),
        }),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('share_result_error'.tr)));
      }
    }
  }

  /// Seçim sheet'ini açar ve seçime göre birleşik widget'ı yakalar
  Future<Uint8List?> _captureWithSelection(
    BuildContext context,
    ScanResultModel result,
  ) async {
    // Basit seçim sheet'i (checkboxlar)
    bool includeImage = true;
    bool includeBasics = true;
    bool includeValue = true;
    bool includeChemical = true;
    bool includeAstro = true;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppThemeConfig.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppThemeConfig.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'top_visual_select_sections'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppThemeConfig.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCheckboxTile(
                    'top_visual_image'.tr,
                    includeImage,
                    (v) => setState(() => includeImage = v),
                  ),
                  _buildCheckboxTile(
                    'top_visual_basics'.tr,
                    includeBasics,
                    (v) => setState(() => includeBasics = v),
                  ),
                  _buildCheckboxTile(
                    'top_visual_price'.tr,
                    includeValue,
                    (v) => setState(() => includeValue = v),
                  ),
                  _buildCheckboxTile(
                    'top_visual_chemical'.tr,
                    includeChemical,
                    (v) => setState(() => includeChemical = v),
                  ),
                  _buildCheckboxTile(
                    'top_visual_astrological'.tr,
                    includeAstro,
                    (v) => setState(() => includeAstro = v),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeConfig.buttonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'top_visual_continue'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );

    // Seçime göre compose et ve yakala
    try {
      final ScreenshotController screenshotController = ScreenshotController();
      final Uint8List imageBytes = await screenshotController
          .captureFromLongWidget(
            InheritedTheme.captureAll(
              // ignore: use_build_context_synchronously
              context,
              Material(
                color: AppThemeConfig.background,
                child: SizedBox(
                  // ignore: use_build_context_synchronously
                  width: MediaQuery.of(context).size.width,
                  child: ShareableGemResultWidget(
                    result: result,
                    includeImage: includeImage,
                    includeBasics: includeBasics,
                    includeValue: includeValue,
                    includeChemical: includeChemical,
                    includeAstro: includeAstro,
                  ),
                ),
              ),
            ),
            delay: const Duration(milliseconds: 120),
            // ignore: use_build_context_synchronously
            context: context,
          );
      return imageBytes;
    } catch (e) {
      if (kDebugMode) {
        print('❌ captureFromLongWidget (seçim) hatası: $e');
      }
      return null;
    }
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? value),
      contentPadding: EdgeInsets.zero,
      activeColor: AppThemeConfig.buttonBackground,
      title: Text(
        title,
        style: TextStyle(
          color: AppThemeConfig.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

/// Fotoğrafı büyük ekranda gösteren sayfa
class _PhotoViewScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const _PhotoViewScreen({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imagePath.startsWith('data:image')) {
      try {
        final base64Str = imagePath.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget();
          },
        );
      } catch (e) {
        return _buildErrorWidget();
      }
    } else {
      return Image.network(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 80, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'top_visual_picture_error'.tr,
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
