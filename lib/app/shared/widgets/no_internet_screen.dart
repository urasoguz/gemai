import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/network_service.dart';
import 'package:gemai/app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Internet bağlantısı olmadığında gösterilen ekran
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkService>();
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // İkon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.appBarColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 60,
                  color: colors.appBarColor,
                ),
              ),

              const SizedBox(height: 32),

              // Başlık
              Text(
                'no_internet_title'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Açıklama
              Text(
                'no_internet_desc'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textColor.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Bağlantı durumu
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        networkService.isConnected.value
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          networkService.isConnected.value
                              ? Colors.green
                              : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        networkService.isConnected.value
                            ? Icons.check_circle
                            : Icons.error,
                        size: 16,
                        color:
                            networkService.isConnected.value
                                ? Colors.green
                                : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        networkService.isConnected.value
                            ? 'no_internet_connection_established'.tr
                            : 'no_internet_connection_not_established'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              networkService.isConnected.value
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Yenile butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Bağlantıyı kontrol et
                    final isConnected = await networkService.checkConnection();
                    if (isConnected) {
                      // Bağlantı varsa uygulamayı yeniden başlat
                      Get.offAllNamed('/');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.appBarColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'no_internet_refresh'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Ayarlar butonu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    // WiFi ayarlarını aç
                    // Bu kısım platform-specific olabilir
                    launchUrl(Uri.parse('settings://'));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.appBarColor,
                    side: BorderSide(color: colors.appBarColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'no_internet_settings'.tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
