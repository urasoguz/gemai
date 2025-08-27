import 'package:dash_flags/dash_flags.dart';
import 'package:gemai/app/core/theme/app_theme_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gemai/app/shared/controllers/lang_controller.dart';
import 'package:gemai/app/core/localization/languages.dart';
import 'package:gemai/app/shared/widgets/modular_app_bar.dart';

class LanguageView extends GetView<LangController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    double lastOffset = 0;
    final LangController langController = Get.find();
    return Scaffold(
      backgroundColor: AppThemeConfig.background,
      appBar: ModularAppBar(
        title: 'settings_language'.tr,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => Get.back(),
          splashColor: AppThemeConfig.transparent,
          highlightColor: AppThemeConfig.transparent,
          hoverColor: AppThemeConfig.transparent,
          focusColor: AppThemeConfig.transparent,
          splashRadius: 0.1,
          enableFeedback: false,
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            final delta =
                (scrollNotification.metrics.pixels - lastOffset).abs();
            if (delta > 40) {
              HapticFeedback.selectionClick();
              lastOffset = scrollNotification.metrics.pixels;
            }
          }
          return false;
        },
        child: ListView(
          children: [
            Obx(() {
              return Column(
                children: [
                  for (String languageCode in Languages.supportedLanguages)
                    Column(
                      children: [
                        _buildLanguageTile(
                          Languages.getLanguageName(languageCode) ?? '',
                          Languages.getCountryFlag(languageCode),
                          languageCode,
                          langController,
                        ),
                        if (languageCode != Languages.supportedLanguages.last)
                          Divider(color: AppThemeConfig.divider, height: 1),
                      ],
                    ),
                ],
              );
            }),
            Divider(color: AppThemeConfig.divider, height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    String language,
    Country country,
    String languageCode,
    LangController langController,
  ) {
    return CustomRadioListTile(
      title: language,
      value: languageCode,
      groupValue: langController.currentLanguage.value,
      onChanged: (String? value) {
        if (value != null) {
          HapticFeedback.selectionClick();
          langController.changeLanguage(value);
        }
      },
      leading: Row(
        children: [
          CountryFlag(country: country, height: 25),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class CustomRadioListTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;
  final Widget? leading;

  const CustomRadioListTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: AppThemeConfig.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppThemeConfig.textLink,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
