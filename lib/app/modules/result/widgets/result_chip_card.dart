import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';

class ResultChipCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color chipColor;
  const ResultChipCard({
    super.key,
    required this.title,
    required this.items,
    required this.chipColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    if (items.isEmpty) return const SizedBox.shrink();
    // Sade chip kartı
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.divider, width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.label_important_outline,
                size: 16,
                color: colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children:
                items
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: chipColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
