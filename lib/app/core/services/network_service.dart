import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

/// Internet bağlantısı kontrolü için servis
///
/// KULLANIM ÖRNEĞİ:
/// ```dart
/// final networkService = Get.find<NetworkService>();
/// final isConnected = networkService.isConnected.value;
/// ```
class NetworkService extends GetxService {
  final RxBool isConnected = true.obs;
  final RxString connectionType = ''.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    _setupConnectivityListener();
  }

  /// Bağlantı durumunu başlatır
  Future<void> _initializeConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _updateConnectionStatus(connectivityResult);

      if (kDebugMode) {
        print('🌐 Network Service başlatıldı:');
        print('   - Bağlantı durumu: ${isConnected.value}');
        print('   - Bağlantı tipi: ${connectionType.value}');
      }
    } catch (e) {
      debugPrint('❌ Network Service başlatma hatası: $e');
      // Hata durumunda varsayılan olarak bağlantı var kabul et
      isConnected.value = true;
      connectionType.value = 'unknown';
    }
  }

  /// Bağlantı değişikliklerini dinler
  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);

      if (kDebugMode) {
        print('🌐 Bağlantı değişikliği:');
        print('   - Yeni durum: ${isConnected.value}');
        print('   - Yeni tip: ${connectionType.value}');
      }
    });
  }

  /// Bağlantı durumunu günceller
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      isConnected.value = false;
      connectionType.value = 'none';
      return;
    }

    // İlk aktif bağlantıyı al
    final activeResult = results.first;

    switch (activeResult) {
      case ConnectivityResult.wifi:
        isConnected.value = true;
        connectionType.value = 'wifi';
        break;
      case ConnectivityResult.mobile:
        isConnected.value = true;
        connectionType.value = 'mobile';
        break;
      case ConnectivityResult.ethernet:
        isConnected.value = true;
        connectionType.value = 'ethernet';
        break;
      case ConnectivityResult.vpn:
        isConnected.value = true;
        connectionType.value = 'vpn';
        break;
      case ConnectivityResult.bluetooth:
        isConnected.value = true;
        connectionType.value = 'bluetooth';
        break;
      case ConnectivityResult.other:
        isConnected.value = true;
        connectionType.value = 'other';
        break;
      case ConnectivityResult.none:
        isConnected.value = false;
        connectionType.value = 'none';
        break;
    }
  }

  /// Bağlantı durumunu kontrol eder
  Future<bool> checkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      _updateConnectionStatus(connectivityResult);
      return isConnected.value;
    } catch (e) {
      debugPrint('❌ Bağlantı kontrolü hatası: $e');
      return false;
    }
  }

  /// Bağlantı tipini string olarak döndürür
  String getConnectionTypeString() {
    switch (connectionType.value) {
      case 'wifi':
        return 'WiFi';
      case 'mobile':
        return 'Mobil Veri';
      case 'ethernet':
        return 'Ethernet';
      case 'vpn':
        return 'VPN';
      case 'bluetooth':
        return 'Bluetooth';
      case 'other':
        return 'Diğer';
      case 'none':
        return 'Bağlantı Yok';
      default:
        return 'Bilinmiyor';
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
