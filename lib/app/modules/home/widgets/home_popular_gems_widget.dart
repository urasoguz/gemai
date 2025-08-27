import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/shared/widgets/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePopularGemsWidget extends StatelessWidget {
  const HomePopularGemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔍 Popular Gems Widget build ediliyor...');

    // Popüler taşlar listesi
    final List<Map<String, String>> popularGems = [
      {'name': 'amethyst', 'image': 'assets/home/popular/amethyst.png'},
      {'name': 'aquamarine', 'image': 'assets/home/popular/aquamarine.png'},
      {'name': 'diamond', 'image': 'assets/home/popular/diamond.png'},
      {'name': 'emerald', 'image': 'assets/home/popular/emerald.png'},
      {'name': 'garnet', 'image': 'assets/home/popular/garnet.png'},
      {'name': 'morganite', 'image': 'assets/home/popular/morganite.png'},
      {'name': 'opal', 'image': 'assets/home/popular/opal.png'},
      {'name': 'pearl', 'image': 'assets/home/popular/pearl.png'},
      {'name': 'peridot', 'image': 'assets/home/popular/peridot.png'},
      {'name': 'ruby', 'image': 'assets/home/popular/ruby.png'},
      {'name': 'sapphire', 'image': 'assets/home/popular/sapphire.png'},
      {'name': 'tanzanite', 'image': 'assets/home/popular/tanzanite.png'},
      {'name': 'topaz', 'image': 'assets/home/popular/topaz.png'},
      {'name': 'tourmaline', 'image': 'assets/home/popular/tourmaline.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern başlık - son işlemler ile aynı boyut
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Başlık için Expanded kullan - taşmayı engeller
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppThemeConfig.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'home_popular_gems_title'.tr,
                      style: TextStyle(
                        fontSize: 16, // Son işlemler ile aynı boyut
                        fontWeight:
                            FontWeight.w600, // Son işlemler ile aynı weight
                        color: AppThemeConfig.textPrimary,
                      ),
                      // Uzun metinler için overflow kontrolü
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Modern yatay kaydırılabilir taş kartları
        SizedBox(
          height: 140, // Yüksekliği azalttım
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: popularGems.length,
            itemBuilder: (context, index) {
              final gem = popularGems[index];
              return GestureDetector(
                onTap: () {
                  // Taşa tıklandığında webview ile blog sayfasını aç
                  final gemName = _capitalizeFirstLetter(gem['name']!);
                  final blogUrl = 'https://gemai.us/blog/$gemName';

                  Get.to(() => WebViewScreen(url: blogUrl, title: gemName));
                },
                child: Container(
                  width: 110, // Genişliği azalttım
                  margin: const EdgeInsets.only(right: 16, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 1),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Taş görseli - tam sığdırma
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              gem['image']!,
                              fit: BoxFit.contain, // contain ile tam sığdırma
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                print('❌ Görsel yüklenemedi: ${gem['image']}');
                                print('❌ Hata: $error');
                                return Container(
                                  color: Colors.grey[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.diamond,
                                        size: 24,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Hata',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Taş adı - minimal padding
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: Text(
                          _capitalizeFirstLetter(gem['name']!),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppThemeConfig.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// İlk harfi büyük yapar
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
