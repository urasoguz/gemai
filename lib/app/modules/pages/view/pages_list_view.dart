import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/modules/pages/controller/pages_controller.dart';
import 'package:gemai/app/routes/app_routes.dart';

/// Pages listesi view'ı
class PagesListView extends StatelessWidget {
  const PagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PagesController>();

    return Scaffold(
      backgroundColor: AppThemeConfig.background,
      appBar: AppBar(
        backgroundColor: AppThemeConfig.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'pages_title'.tr,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppThemeConfig.primary),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
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
                  onPressed: controller.refreshPages,
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
          );
        }

        if (controller.pages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: AppThemeConfig.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'pages_empty'.tr,
                  style: TextStyle(
                    color: AppThemeConfig.textSecondary,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.refreshPages(),
          color: AppThemeConfig.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return _buildPageCard(page);
            },
          ),
        );
      }),
    );
  }

  /// Sayfa kartı widget'ı
  Widget _buildPageCard(dynamic page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.pageDetail, arguments: {'slug': page.slug});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppThemeConfig.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPageIcon(page.slug),
                  color: AppThemeConfig.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.translation.title,
                      style: TextStyle(
                        color: AppThemeConfig.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (page.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        page.description,
                        style: TextStyle(
                          color: AppThemeConfig.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppThemeConfig.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Sayfa slug'ına göre ikon döndürür
  IconData _getPageIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'terms':
        return Icons.description_outlined;
      case 'privacy':
        return Icons.privacy_tip_outlined;
      case 'about':
        return Icons.info_outline;
      case 'contact':
        return Icons.contact_support_outlined;
      case 'faq':
        return Icons.help_outline;
      default:
        return Icons.article_outlined;
    }
  }
}
