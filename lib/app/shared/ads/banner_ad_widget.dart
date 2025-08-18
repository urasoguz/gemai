import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ad_service.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adService = Get.find<AdService>();
    return adService.buildBanner();
  }
}
