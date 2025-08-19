import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/pages/controller/page_detail_controller.dart';
import 'package:gemai/app/shared/widgets/simple_html_view.dart';

/// Sayfa detayı view'ı
class PageDetailView extends StatelessWidget {
  const PageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PageDetailController>();

    // Controller'a arguments'ı yükle
    controller.loadPageFromArguments();

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: AppThemeConfig.background,
          appBar: AppBar(
            backgroundColor: AppThemeConfig.background,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'loading'.tr,
              style: TextStyle(
                color: AppThemeConfig.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppThemeConfig.textPrimary),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(
            child: CircularProgressIndicator(color: AppThemeConfig.primary),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          backgroundColor: AppThemeConfig.background,
          appBar: AppBar(
            backgroundColor: AppThemeConfig.background,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'error'.tr,
              style: TextStyle(
                color: AppThemeConfig.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppThemeConfig.textPrimary),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppThemeConfig.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.refreshPageDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppThemeConfig.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.pageDetail.value == null) {
        return Scaffold(
          backgroundColor: AppThemeConfig.background,
          appBar: AppBar(
            backgroundColor: AppThemeConfig.background,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'page_not_found'.tr,
              style: TextStyle(
                color: AppThemeConfig.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppThemeConfig.textPrimary),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(
            child: Text(
              'page_not_found'.tr,
              style: TextStyle(
                color: AppThemeConfig.textSecondary,
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      // SimpleHtmlView ile sayfa içeriğini göster
      return SimpleHtmlView(
        title: controller.pageTitle,
        htmlContent: controller.pageContent,
        showAppBar: true,
      );
    });
  }
}
