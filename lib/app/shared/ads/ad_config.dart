import 'admob_adapter.dart';
import 'ad_provider.dart';

class AdConfig {
  static const String bannerId = 'ca-app-pub-xxx/yyy';
  static const String interstitialId = 'ca-app-pub-xxx/zzz';
  static const String rewardedId = 'ca-app-pub-xxx/aaa';

  static List<IAdProvider> getProviders() => [
    AdMobAdapter(),
    // Diğer providerlar buraya eklenir (ör. IronSourceAdapter(), AppLovinAdapter())
  ];
}
