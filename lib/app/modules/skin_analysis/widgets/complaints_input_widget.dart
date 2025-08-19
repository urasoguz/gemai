import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';

class ComplaintsInputWidget extends StatefulWidget {
  final VoidCallback? onFocus;
  const ComplaintsInputWidget({super.key, this.onFocus});
  @override
  State<ComplaintsInputWidget> createState() => _ComplaintsInputWidgetState();
}

class _ComplaintsInputWidgetState extends State<ComplaintsInputWidget> {
  late final TextEditingController _controller;
  final SkinAnalysisController controller = Get.find();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: controller.complaints.value);
    _controller.addListener(() {
      controller.updateComplaints(_controller.text);
    });
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && widget.onFocus != null) {
      widget.onFocus!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.colors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'skin_analysis_complaints'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: colors.buttonShadow.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(
              () => TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 6,
                maxLength: 500,
                enabled: !controller.isAnalyzing.value,
                textInputAction: TextInputAction.done,
                onTap: () {
                  // TextField'a tıklanınca da scroll tetikle
                  if (widget.onFocus != null) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      widget.onFocus!();
                    });
                  }
                },
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'skin_analysis_complaints_hint'.tr,
                  hintStyle: TextStyle(color: colors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  counterStyle: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color:
                      controller.isAnalyzing.value
                          ? colors.textHint
                          : colors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          Obx(() {
            final charCount = controller.complaints.value.length;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$charCount${'skin_analysis_complaints_char_count'.tr}',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      charCount > 450 ? colors.warning : colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
