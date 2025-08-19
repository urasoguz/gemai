import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/core/services/shrine_dialog_service.dart';
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
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    _controller.reverse();
    if (remainingToken == 0 && ispremium == true) {
      ShrineDialogService.showInfo('scan_dialog_125'.tr, colors);
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
    // Tema renklerini al
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;

    return Column(
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedBuilder(
            animation: _scaleAnim,
            builder: (context, child) {
              return Transform.scale(scale: _scaleAnim.value, child: child);
            },
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colors.gradientPrimary,
                        colors.gradientSecondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.buttonShadow.withValues(alpha: 0.10),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.analyzeButton,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.buttonShadow.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.camera_viewfinder,
                        color: colors.analyzeButtonIcon,
                        size: 38,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'home_analyze_button_title'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
