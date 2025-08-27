import 'package:flutter/material.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:gemai/app/modules/gem_result/widgets/temel_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/value_section_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/kimyasal_tab_widget.dart';
import 'package:gemai/app/modules/gem_result/widgets/astrolojik_tab_widget.dart';
import 'package:gemai/app/modules/result/widgets/result_image_widget.dart';

/// Paylaşım/indirme için tüm sonuç içeriğini tek bir görselde toplayan widget
class ShareableGemResultWidget extends StatelessWidget {
  final ScanResultModel result;
  final bool includeImage;
  final bool includeBasics;
  final bool includeValue;
  final bool includeChemical;
  final bool includeAstro;

  const ShareableGemResultWidget({
    super.key,
    required this.result,
    this.includeImage = true,
    this.includeBasics = true,
    this.includeValue = true,
    this.includeChemical = true,
    this.includeAstro = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemeConfig.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (includeImage)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppThemeConfig.buttonShadow.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ResultImageWidget(
                  imagePath: result.imagePath,
                  width: 160,
                  height: 110,
                  borderRadius: 16,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
            ),

          if (includeBasics) TemelTabWidget(data: result),
          if (includeValue) ValueSectionWidget(data: result),
          if (includeChemical) KimyasalTabWidget(data: result),
          if (includeAstro) AstrolojikTabWidget(data: result),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
