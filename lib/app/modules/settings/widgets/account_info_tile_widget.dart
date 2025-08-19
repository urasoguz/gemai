import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class AccountInfoTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget value;
  final Color? valueColor;

  const AccountInfoTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // İkon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.divider,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colors.textPrimary, size: 20),
          ),

          const SizedBox(width: 16),

          // Başlık
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),

          // Değer
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? colors.textPrimary,
            ),
            child: value,
          ),
        ],
      ),
    );
  }
}
