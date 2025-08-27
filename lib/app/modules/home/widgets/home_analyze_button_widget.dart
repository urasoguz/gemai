import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/helpers/my_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/core/services/shrine_dialog_service.dart';
import 'package:get_storage/get_storage.dart';

class HomeAnalyzeButtonWidget extends StatefulWidget {
  const HomeAnalyzeButtonWidget({super.key});

  @override
  State<HomeAnalyzeButtonWidget> createState() =>
      _HomeAnalyzeButtonWidgetState();
}

class _HomeAnalyzeButtonWidgetState extends State<HomeAnalyzeButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final ispremium = GetStorage().read(MyHelper.isAccountPremium);
  final remainingToken = GetStorage().read(MyHelper.accountRemainingToken);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (remainingToken == 0 && ispremium == true) {
      ShrineDialogService.showInfo(
        'home_premium_token_error'.tr,
        AppThemeConfig.textLink,
      );
    } else if (remainingToken == 0 && ispremium == false) {
      Get.toNamed(AppRoutes.premium);
    } else {
      Get.toNamed(AppRoutes.camera);
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppThemeConfig.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          children: [
            // Üstteki görsel (assets/home/home_top.png) - sınırlı
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/home/home_top.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.fill,
              ),
            ),

            const SizedBox(height: 16),

            // Ana başlık
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Text(
                'home_rock_title'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppThemeConfig.textPrimary,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 2),

            // Alt başlık
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Text(
                'home_rock_desc'.tr,
                style: TextStyle(
                  fontSize: 13,
                  color: AppThemeConfig.textSecondary,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Identify butonu
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: AnimatedBuilder(
                animation: _scaleAnim,
                builder: (context, child) {
                  return Transform.scale(scale: _scaleAnim.value, child: child);
                },
                child: Container(
                  width: 200,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [
                        AppThemeConfig.gradientPrimary,
                        AppThemeConfig.gradientSecondary,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemeConfig.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppThemeConfig.white, size: 20),
                      const SizedBox(width: 3),
                      Text(
                        'home_rock_button'.tr,
                        style: TextStyle(
                          color: AppThemeConfig.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
