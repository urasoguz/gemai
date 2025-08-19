import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:gemai/app/routes/app_routes.dart';
import 'package:gemai/app/shared/widgets/modular_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gemai/app/modules/skin_analysis/controller/skin_analysis_controller.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/image_result_widget.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/age_selector_widget.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/body_parts_selector_widget.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/complaints_input_widget.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/analysis_button_widget.dart';
import 'package:gemai/app/modules/skin_analysis/widgets/analysis_scanning_overlay.dart';

class SkinAnalysisView extends StatefulWidget {
  const SkinAnalysisView({super.key});
  @override
  State<SkinAnalysisView> createState() => _SkinAnalysisViewState();
}

class _SkinAnalysisViewState extends State<SkinAnalysisView> {
  final ScrollController _scrollController = ScrollController();

  void scrollToBottom() {
    // Klavye açılma animasyonu için daha uzun bekleme
    Future.delayed(const Duration(milliseconds: 600), () {
      if (_scrollController.hasClients) {
        // Maksimum scroll pozisyonuna git
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SkinAnalysisController());

    return GetBuilder<SkinAnalysisController>(
      builder: (controller) {
        return Obx(() {
          return PopScope(
            canPop: !controller.isAnalyzing.value,
            child: AbsorbPointer(
              absorbing: controller.isAnalyzing.value,
              // ignore: deprecated_member_use
              child: WillPopScope(
                onWillPop: () async {
                  if (controller.isAnalyzing.value) {
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                  backgroundColor: AppThemeConfig.background,
                  appBar: ModularAppBar(
                    title: 'skin_analysis_title'.tr,
                    elevation: 0,
                    leading: Obx(() {
                      final currentController =
                          Get.find<SkinAnalysisController>();
                      return IconButton(
                        icon: const Icon(CupertinoIcons.back, size: 30),
                        onPressed:
                            currentController.isAnalyzing.value
                                ? null
                                : () => Get.offAllNamed(AppRoutes.home),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashRadius: 0.1,
                        enableFeedback: false,
                      );
                    }),
                  ),
                  body: SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(
                                  bottom: 30,
                                ), // Minimal padding
                                child: Column(
                                  children: [
                                    const ImageResultWidget(),
                                    const AgeSelectorWidget(),
                                    const BodyPartsSelectorWidget(),
                                    ComplaintsInputWidget(
                                      onFocus: scrollToBottom,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const AnalysisButtonWidget(),
                          ],
                        ),
                        Obx(
                          () => AnalysisScanningOverlay(
                            isVisible: controller.isAnalyzing.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
