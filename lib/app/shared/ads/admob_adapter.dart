import 'package:flutter/material.dart';
import 'ad_provider.dart';

class AdMobAdapter implements IAdProvider {
  @override
  Future<void> init() async {
    // AdMob SDK init işlemleri burada yapılır
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget buildBanner({Key? key}) {
    // Gerçek reklam yerine mock bir kutu
    return Container(
      key: key,
      height: 50,
      color: Colors.blue[100],
      alignment: Alignment.center,
      child: const Text('AdMob Banner', style: TextStyle(color: Colors.blue)),
    );
  }

  @override
  Future<void> showInterstitial() async {
    // Gerçek reklam yerine mock dialog
    debugPrint('AdMob Interstitial shown');
  }

  @override
  Future<void> showRewarded({required VoidCallback onReward}) async {
    // Gerçek reklam yerine mock ödül
    debugPrint('AdMob Rewarded shown');
    onReward();
  }

  @override
  bool get isAvailable => true; // Gerçek kullanımda SDK ready kontrolü

  @override
  String get providerName => 'AdMob';
}
