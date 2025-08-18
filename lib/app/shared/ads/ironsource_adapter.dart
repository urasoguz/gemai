import 'package:flutter/material.dart';
import 'ad_provider.dart';

class IronSourceAdapter implements IAdProvider {
  @override
  Future<void> init() async {
    // IronSource SDK init işlemleri burada yapılır
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget buildBanner({Key? key}) {
    // Gerçek reklam yerine mock bir kutu
    return Container(
      key: key,
      height: 50,
      color: Colors.orange[100],
      alignment: Alignment.center,
      child: const Text(
        'IronSource Banner',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }

  @override
  Future<void> showInterstitial() async {
    debugPrint('IronSource Interstitial shown');
  }

  @override
  Future<void> showRewarded({required VoidCallback onReward}) async {
    debugPrint('IronSource Rewarded shown');
    onReward();
  }

  @override
  bool get isAvailable => true;

  @override
  String get providerName => 'IronSource';
}
