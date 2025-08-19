import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class ModularAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final bool showBottomBorder;
  final Color? bottomBorderColor;
  final double bottomBorderHeight;

  const ModularAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.showBottomBorder = true,
    this.bottomBorderColor,
    this.bottomBorderHeight = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    return AppBar(
      backgroundColor: backgroundColor ?? colors.background,
      foregroundColor: foregroundColor ?? colors.textPrimary,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color: foregroundColor ?? colors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      actions: trailing != null ? [trailing!] : null,
      bottom:
          showBottomBorder
              ? PreferredSize(
                preferredSize: Size.fromHeight(bottomBorderHeight),
                child: Container(
                  color: bottomBorderColor ?? colors.divider,
                  height: bottomBorderHeight,
                ),
              )
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
