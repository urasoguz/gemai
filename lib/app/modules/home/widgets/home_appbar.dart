import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 48), // IconButton ile aynı genişlik
                Expanded(
                  child: Center(
                    child: Text(
                      AppThemeConfig.appName,
                      style: GoogleFonts.koHo(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color:
                            Theme.of(context).brightness == Brightness.light
                                ? AppThemeConfig.colors.textPrimary
                                : AppThemeConfig.colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    CupertinoIcons.settings,
                    size: 26,
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? AppThemeConfig.colors.textPrimary
                            : AppThemeConfig.colors.textPrimary,
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.settings);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashRadius:
                      0.1, // çok küçük yaparak dalga yayılmasını engelle
                  enableFeedback:
                      false, // titreşim ses gibi sistem geri bildirimlerini de kapatır
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color:
                Theme.of(context).brightness == Brightness.light
                    ? AppThemeConfig.colors.divider
                    : AppThemeConfig.colors.divider,
          ),
        ],
      ),
    );
  }
}
