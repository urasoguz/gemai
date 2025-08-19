import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';

/// Yaş seçici widget'ı
/// Dropdown menü ile yaş seçimi
class AgeSelectorWidget extends StatefulWidget {
  const AgeSelectorWidget({super.key});
  @override
  State<AgeSelectorWidget> createState() => _AgeSelectorWidgetState();
}

class _AgeSelectorWidgetState extends State<AgeSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SkinAnalysisController>();
    final List<String> ageList = [
      'skin_analysis_age_info_1'.tr,
      ...controller.ageList.map((e) => '$e ${'skin_analysis_age_info'.tr}'),
    ];
    final colors =
        AppThemeConfig.colors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'skin_analysis_age'.tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonShadow.withValues(alpha: 0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Obx(
              () => CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: controller.selectedAge.value,
                ),
                itemExtent: 36,
                magnification: 1.08,
                squeeze: 1.1,
                useMagnifier: true,
                backgroundColor: Colors.transparent,
                onSelectedItemChanged:
                    controller.isAnalyzing.value
                        ? null
                        : (int index) {
                          if (index == 0) {
                            controller.selectAge(1); // 0 yerine 1 gönder
                          } else {
                            controller.selectAge(index);
                          }
                          setState(() {});
                        },
                children:
                    ageList
                        .map(
                          (e) => Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    controller.isAnalyzing.value
                                        ? colors.textHint
                                        : colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
