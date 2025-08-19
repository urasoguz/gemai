import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/settings/controller/settings_controller.dart';
import 'package:dermai/app/modules/settings/widgets/user_info_widget.dart';
import 'package:dermai/app/shared/controllers/lang_controller.dart';
import 'package:dermai/app/core/localization/languages.dart';
import 'package:dermai/app/shared/widgets/modular_app_bar.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:dermai/app/core/services/revenuecat_service.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    final colors =
        AppThemeConfig.primary;
    return Scaffold(
      appBar: ModularAppBar(
        title: 'settings_title'.tr,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 30),
          onPressed: () => Get.back(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashRadius: 0.1,
          enableFeedback: false,
        ),
      ),

      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              // Kullanıcı bilgileri
              const UserInfoWidget(),

              Divider(height: 1, thickness: 1, color: colors.divider),

              // Dil ayarları
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () async {
                    final result = await Get.toNamed(AppRoutes.language);
                    if (result == true) {
                      setState(() {}); // Dil değiştiyse ekranı yeniden çiz
                    }
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_language'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  Languages.getLanguageName(
                                        Get.find<LangController>()
                                            .currentLanguage
                                            .value,
                                      ) ??
                                      'English',
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: colors.textPrimary,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Tema ayarları
              Obx(
                () => Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'settings_dark_mode'.tr,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                        CupertinoSwitch(
                          value: controller.isDarkMode.value,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            controller.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: colors.divider),

              // SSS
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    controller.openFAQ();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_faq'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colors.textPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Hakkında
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    controller.openAbout();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_about'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colors.textPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // İletişim
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    controller.contactUs();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_contact'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colors.textPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: colors.divider),

              // // Premium'a geç
              // Material(
              //   color: Colors.transparent,
              //   child: InkWell(
              //     splashColor: Colors.transparent,
              //     highlightColor: Colors.transparent,
              //     hoverColor: Colors.transparent,
              //     onTap: () {
              //       // RevenueCat paywall'ı aç
              //       RevenueCatService.showRevenueCatPaywall(
              //         paywallId: 'Plans-1',
              //       );
              //     },
              //     child: Container(
              //       alignment: Alignment.bottomLeft,
              //       child: Padding(
              //         padding: const EdgeInsets.only(
              //           top: 15,
              //           bottom: 15,
              //           left: 10,
              //           right: 10,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Premium\'a Geç',
              //               style: TextStyle(
              //                 color: colors.textPrimary,
              //                 fontSize: 18,
              //               ),
              //             ),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               color: colors.textPrimary,
              //               size: 16,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Satın almaları geri yükle
              if (GetStorage().read(MyHelper.isAccountPremium) == false)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      controller.restorePurchases();
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'settings_restore_purchases'.tr,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 18,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: colors.textPrimary,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Uygulamayı paylaş
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    controller.shareApp();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_share'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colors.textPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Uygulamayı değerlendir
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    controller.rateApp();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'settings_rate'.tr,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: colors.textPrimary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Divider(height: 1, thickness: 1, color: colors.divider),

              const SizedBox(height: 20),

              // Versiyon bilgisi
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    MyHelper.appname.toUpperCase(),
                    style: GoogleFonts.koHo(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${'settings_version'.tr} ${controller.appVersion.value}',
                      style: GoogleFonts.koHo(
                        fontSize: 14,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: <Widget>[
                      // Gizlilik Politikası
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {
                            controller.openPrivacyPolicy();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              'settings_privacy'.tr,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Ayraç nokta
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '•',
                          style: TextStyle(color: colors.divider, fontSize: 16),
                        ),
                      ),

                      // Hizmet Şartları
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {
                            controller.openTerms();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              'settings_terms'.tr,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
