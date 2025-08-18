import 'package:flutter/material.dart';

abstract class IAdProvider {
  Future<void> init();
  Widget buildBanner({Key? key});
  Future<void> showInterstitial();
  Future<void> showRewarded({required VoidCallback onReward});
  bool get isAvailable;
  String get providerName;
}
