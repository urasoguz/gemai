import 'package:dermai/app/core/services/shrine_dialog_service.dart';
import 'package:dermai/app/core/theme/app_theme_config.dart';
import 'package:dermai/app/shared/helpers/my_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dermai/app/modules/home/controller/home_controller.dart';
import 'package:dermai/app/modules/home/widgets/home_appbar.dart';
import 'package:dermai/app/modules/home/widgets/home_action_button.dart';
import 'package:dermai/app/modules/home/widgets/home_bottom_navbar.dart';
import 'package:dermai/app/modules/history/view/history_view.dart';
import 'package:dermai/app/modules/home/widgets/home_welcome_widget.dart';
import 'package:dermai/app/modules/home/widgets/home_analyze_button_widget.dart';
import 'package:dermai/app/modules/home/widgets/home_tip_widget.dart';
import 'package:dermai/app/modules/home/widgets/home_recent_history_widget.dart';
import 'package:dermai/app/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final colors =
        AppThemeConfig.primary;
    final ispremium = GetStorage().read(MyHelper.isAccountPremium);
    final remainingToken = GetStorage().read(MyHelper.accountRemainingToken);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HomeAppBar(),
      ),
      body: Obx(() {
        if (controller.selectedTab.value == 0) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 15),
                const HomeWelcomeWidget(),
                const SizedBox(height: 28),
                const HomeAnalyzeButtonWidget(),
                const SizedBox(height: 15),
                const HomeTipWidget(),
                const SizedBox(height: 35),
                const HomeRecentHistoryWidget(),
                const SizedBox(height: 32),
              ],
            ),
          );
        } else {
          return HistoryView();
        }
      }),
      bottomNavigationBar: Obx(
        () => HomeBottomNavBar(
          selectedTab: controller.selectedTab.value,
          onTabSelected: controller.changeTab,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: HomeActionButton(
        onPressed: () {
          if (remainingToken == 0 && ispremium == true) {
            ShrineDialogService.showInfo('scan_dialog_125'.tr, colors);
          } else if (remainingToken == 0 && ispremium == false) {
            Get.toNamed(AppRoutes.premium);
          } else {
            Get.toNamed(AppRoutes.camera);
          }
        },
      ),
    );
  }
}
