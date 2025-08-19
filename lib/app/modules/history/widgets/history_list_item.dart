import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/core/services/sembast_service.dart';
import 'package:dermai/app/core/services/date_formatting_service.dart';
import 'package:dermai/app/modules/result/widgets/result_image_widget.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final int index;
  final VoidCallback onTap;
  const HistoryListItem({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).brightness == Brightness.light
            ? AppThemeConfig.lightColors
            : AppThemeConfig.darkColors;
    final model = item.model;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: colors.background,
        borderRadius: BorderRadius.circular(14),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: colors.divider.withValues(alpha: 0.06),
          highlightColor: colors.divider.withValues(alpha: 0.03),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonShadow.withValues(alpha: 0.025),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.card,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child:
                        model.imagePath != null && model.imagePath!.isNotEmpty
                            ? ResultImageWidget(
                              imagePath: model.imagePath,
                              width: 38,
                              height: 38,
                              borderRadius: 10,
                              margin: EdgeInsets.zero,
                            )
                            : Icon(
                              Icons.image,
                              size: 20,
                              color: colors.textHint,
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.name ?? '-',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          letterSpacing: 0.05,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              model.altName ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (model.createdAt != null) ...[
                            const SizedBox(width: 8),
                            FutureBuilder<String>(
                              future: _getFormattedDate(model.createdAt!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: colors.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tarih formatlaması için yardımcı metod
  Future<String> _getFormattedDate(DateTime dateTime) async {
    final dateService = Get.find<DateFormattingService>();
    return await dateService.formatRelativeDate(dateTime);
  }
}
