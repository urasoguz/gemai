import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PremiumConfigService extends GetxService {
  final box = GetStorage();

  /// Backend'den gelen ayar: Kapat butonu gecikmeli mi?
  bool get delayedCloseButton => box.read('delayed_close_button') ?? false;

  /// Backend'den gelen ayar: Gecikme süresi (saniye)
  int get closeButtonDelaySeconds => box.read('close_button_delay') ?? 5;

  /// Backend'den premium config ayarlarını çekip localde saklar
  Future<void> fetchPremiumConfigFromBackend() async {
    // Burada gerçek API çağrısı yapılabilir
    // final config = await api.getPremiumConfig();
    // box.write('delayed_close_button', config['delayedCloseButton']);
    // box.write('close_button_delay', config['closeButtonDelaySeconds']);
  }
}
