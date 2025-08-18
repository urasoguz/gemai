import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ad_provider.dart';

class AdService extends GetxService {
  final List<IAdProvider> providers;
  final IAdProvider fallbackProvider;

  AdService({required this.providers, required this.fallbackProvider});

  IAdProvider get activeProvider =>
      providers.firstWhereOrNull((p) => p.isAvailable) ?? fallbackProvider;

  Future<void> initAll() async {
    for (final p in providers) {
      await p.init();
    }
  }

  Widget buildBanner({Key? key}) => activeProvider.buildBanner(key: key);
  Future<void> showInterstitial() => activeProvider.showInterstitial();
  Future<void> showRewarded({required VoidCallback onReward}) =>
      activeProvider.showRewarded(onReward: onReward);
}
