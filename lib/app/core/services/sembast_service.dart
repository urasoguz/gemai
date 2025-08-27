import 'package:gemai/app/data/model/response/scan_result_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:flutter/foundation.dart';

class HistoryItem {
  final int id;
  final ScanResultModel model;
  HistoryItem(this.id, this.model);
}

class SembastService {
  // Singleton instance
  static final SembastService _instance = SembastService._internal();
  factory SembastService() => _instance;
  SembastService._internal();

  // Database ve store tanımları
  Database? _db;
  final _store = intMapStoreFactory.store('scan_results');
  static const int _dbVersion = 2; // Versiyon artırıldı

  // Veritabanı bağlantısı getter'ı
  Future<Database> get db async {
    return _db ??= await _initDatabase();
  }

  // Veritabanı başlatma (optimize edilmiş)
  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/gemai.db';
    return await databaseFactoryIo.openDatabase(
      dbPath,
      version: _dbVersion,
      onVersionChanged: _onVersionChanged,
    );
  }

  // Versiyon değişikliği handler'ı
  Future<void> _onVersionChanged(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Eski verileri temizle - type mismatch'leri önlemek için
      await _store.delete(db);
      if (kDebugMode) {
        print(
          '🔄 Veritabanı versiyonu 2\'ye güncellendi, eski veriler temizlendi',
        );
      }
    }
  }

  /// Tarama sonucu ekleme
  ///
  /// Args:
  /// - model: ScanResultModel
  /// - base64Image: Base64 encoded görsel (opsiyonel)
  ///
  /// Returns:
  /// - int: Kaydedilen kaydın ID'si
  Future<int> addScanResult(
    ScanResultModel model, {
    String? base64Image,
  }) async {
    try {
      if (kDebugMode) {
        print(
          '💾 addScanResult başladı - Model isFavorite: ${model.isFavorite}',
        );
        print(
          '💾 addScanResult - Model imagePath: ${model.imagePath != null ? "Mevcut (${model.imagePath!.length} karakter)" : "Yok"}',
        );
        print(
          '💾 addScanResult - base64Image parametresi: ${base64Image != null ? "Mevcut (${base64Image.length} karakter)" : "Yok"}',
        );
      }

      // Model'i map'e çevir
      final Map<String, dynamic> data = model.toMap();

      // id'yi kaldır - veritabanı otomatik oluşturacak
      data.remove('id');

      // isFavorite null ise false olarak ayarla
      if (data['is_favorite'] == null) {
        data['is_favorite'] = false;
      }

      if (kDebugMode) {
        print('💾 addScanResult - Map is_favorite: ${data['is_favorite']}');
        print(
          '💾 addScanResult - Map imagePath: ${data['imagePath'] != null ? "Mevcut (${data['imagePath'].length} karakter)" : "Yok"}',
        );
        print('💾 addScanResult - Map createdAt: ${data['createdAt']}');
        print('💾 addScanResult - Map created_at: ${data['created_at']}');
        print('💾 addScanResult - Tüm data keys: ${data.keys.toList()}');
      }

      // Base64 görsel varsa ekle
      if (base64Image != null && base64Image.isNotEmpty) {
        data['base64_image'] = base64Image;
        if (kDebugMode) {
          print(
            '💾 Base64 görsel eklendi - Boyut: ${base64Image.length} karakter',
          );
        }
      }

      // Veritabanına kaydet
      final int id = await _store.add(await db, data);

      if (kDebugMode) {
        print(
          '✅ Scan result kaydedildi - ID: $id, is_favorite: ${data['is_favorite']}',
        );
        print(
          '✅ Kaydedilen data imagePath: ${data['imagePath'] != null ? "Mevcut (${data['imagePath'].length} karakter)" : "Yok"}',
        );
        print(
          '✅ Kaydedilen data base64_image: ${data['base64_image'] != null ? "Mevcut (${data['base64_image'].length} karakter)" : "Yok"}',
        );
      }

      return id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Scan result kaydetme hatası: $e');
      }
      rethrow;
    }
  }

  // Tüm sonuçları getirme (sıralı) - id ve model birlikte döner
  Future<List<HistoryItem>> getAllResults() async {
    if (kDebugMode) {
      print('🔍 getAllResults - DateTime sıralama testi başladı');
      print(
        '🔍 getAllResults - SortOrder: created_at, false (DateTime azalan) kullanılıyor',
      );
    }

    final snapshots = await _store.find(
      await db,
      finder: Finder(
        sortOrders: [
          SortOrder('created_at', false),
        ], // false = azalan sıralama (yeni → eski)
      ),
    );

    if (kDebugMode) {
      print('🔍 getAllResults - Toplam kayıt sayısı: ${snapshots.length}');
      print('🔍 getAllResults - Sıralama: yeni → eski (DateTime azalan)');
      print(
        '🔍 getAllResults - SortOrder: created_at, false (DateTime azalan)',
      );

      // Ham veriyi kontrol et
      print('🔍 getAllResults - Ham veri sıralaması:');
      for (int i = 0; i < snapshots.length && i < 5; i++) {
        final snap = snapshots[i];
        final createdAt = snap.value['created_at'];
        if (kDebugMode) {
          print(
            '🔍 getAllResults - Index $i: Key=${snap.key}, created_at=$createdAt',
          );
        }
      }
    }

    final result =
        snapshots.map((snap) {
          final updatedValue = Map<String, dynamic>.from(snap.value);
          updatedValue['id'] = snap.key;

          // Base64 görseli varsa snap.value'ya ekle
          if (snap.value['base64_image'] != null) {
            updatedValue['imagePath'] = snap.value['base64_image'];
          }

          // is_favorite alanını doğru şekilde handle et
          if (snap.value['is_favorite'] != null) {
            updatedValue['is_favorite'] = snap.value['is_favorite'];
            if (kDebugMode) {
              print(
                '🔍 getAllResults - ID: ${snap.key}, is_favorite: ${snap.value['is_favorite']}',
              );
            }
          } else {
            if (kDebugMode) {
              print(
                '🔍 getAllResults - ID: ${snap.key}, is_favorite: null (false olarak ayarlanacak)',
              );
            }
            updatedValue['is_favorite'] = false;
          }

          final model = ScanResultModel.fromMap(updatedValue);
          return HistoryItem(snap.key, model);
        }).toList();

    if (kDebugMode && result.isNotEmpty) {
      if (kDebugMode) {
        print('🔍 getAllResults - Sonuç sıralaması kontrolü:');
      }
      if (kDebugMode) {
        print(
          '🔍 getAllResults - İlk öğe (en yeni): ID: ${result.first.id}, Tarih: ${result.first.model.createdAt}',
        );
      }
      if (kDebugMode) {
        print(
          '🔍 getAllResults - Son öğe (en eski): ID: ${result.last.id}, Tarih: ${result.last.model.createdAt}',
        );

        // Tüm sonuçları tarihe göre kontrol et
        print('🔍 getAllResults - Tüm sonuçlar tarih sırasına göre:');
        for (int i = 0; i < result.length; i++) {
          final item = result[i];
          print(
            '🔍 getAllResults - Index $i: ID=${item.id}, Tarih=${item.model.createdAt}',
          );
        }
      }
    }

    return result;
  }

  /// Sadece favori sonuçları getirme
  Future<List<HistoryItem>> getFavoriteResults() async {
    if (kDebugMode) {
      print('🔍 getFavoriteResults - DateTime sıralama testi başladı');
      print(
        '🔍 getFavoriteResults - SortOrder: created_at, false (DateTime azalan) kullanılıyor',
      );
    }

    final snapshots = await _store.find(
      await db,
      finder: Finder(
        filter: Filter.equals('is_favorite', true),
        sortOrders: [
          SortOrder(
            'created_at',
            false,
          ), // false = azalan sıralama (yeni → eski)
        ],
      ),
    );

    if (kDebugMode) {
      print('🔍 getFavoriteResults - Favori kayıt sayısı: ${snapshots.length}');
      print('🔍 getFavoriteResults - Sıralama: yeni → eski (DateTime azalan)');
      print(
        '🔍 getFavoriteResults - SortOrder: created_at, false (DateTime azalan)',
      );

      // Ham veriyi kontrol et
      print('🔍 getFavoriteResults - Ham veri sıralaması:');
      for (int i = 0; i < snapshots.length && i < 5; i++) {
        final snap = snapshots[i];
        final createdAt = snap.value['created_at'];
        print(
          '🔍 getFavoriteResults - Index $i: Key=${snap.key}, created_at=$createdAt',
        );
      }
    }

    final result =
        snapshots.map((snap) {
          final updatedValue = Map<String, dynamic>.from(snap.value);
          updatedValue['id'] = snap.key;

          // Base64 görseli varsa snap.value'ya ekle
          if (snap.value['base64_image'] != null) {
            updatedValue['imagePath'] = snap.value['base64_image'];
          }

          // is_favorite alanını doğru şekilde handle et
          if (snap.value['is_favorite'] != null) {
            updatedValue['is_favorite'] = snap.value['is_favorite'];
            if (kDebugMode) {
              print(
                '🔍 getFavoriteResults - ID: ${snap.key}, is_favorite: ${snap.value['is_favorite']}',
              );
            }
          }

          final model = ScanResultModel.fromMap(updatedValue);
          return HistoryItem(snap.key, model);
        }).toList();

    if (kDebugMode && result.isNotEmpty) {
      if (kDebugMode) {
        print('🔍 getFavoriteResults - Sonuç sıralaması kontrolü:');
      }
      if (kDebugMode) {
        print(
          '🔍 getFavoriteResults - İlk öğe (en yeni): ID: ${result.first.id}, Tarih: ${result.first.model.createdAt}',
        );
      }
      if (kDebugMode) {
        print(
          '🔍 getFavoriteResults - Son öğe (en eski): ID: ${result.last.id}, Tarih: ${result.last.model.createdAt}',
        );

        // Tüm sonuçları tarihe göre kontrol et
        if (kDebugMode) {
          print('🔍 getFavoriteResults - Tüm sonuçlar tarih sırasına göre:');
        }
        for (int i = 0; i < result.length; i++) {
          final item = result[i];
          if (kDebugMode) {
            print(
              '🔍 getFavoriteResults - Index $i: ID=${item.id}, Tarih=${item.model.createdAt}',
            );
          }
        }
      }
    }

    return result;
  }

  // Tek bir sonuç getirme
  Future<ScanResultModel?> getResult(int key) async {
    final snapshot = await _store.record(key).getSnapshot(await db);
    if (snapshot != null) {
      if (kDebugMode) {
        print('🔍 getResult - Snapshot bulundu - ID: $key');
        print('🔍 getResult - Snapshot keys: ${snapshot.value.keys.toList()}');
        print(
          '🔍 getResult - Snapshot base64_image: ${snapshot.value['base64_image'] != null ? "Mevcut (${(snapshot.value['base64_image'] as String).length} karakter)" : "Yok"}',
        );
        print(
          '🔍 getResult - Snapshot imagePath: ${snapshot.value['imagePath'] != null ? "Mevcut (${(snapshot.value['imagePath'] as String).length} karakter)" : "Yok"}',
        );
        print(
          '🔍 getResult - Snapshot createdAt: ${snapshot.value['createdAt']}',
        );
        print(
          '🔍 getResult - Snapshot created_at: ${snapshot.value['created_at']}',
        );
      }

      final updatedValue = Map<String, dynamic>.from(snapshot.value);
      updatedValue['id'] = snapshot.key;

      // Base64 görseli varsa snap.value'ya ekle
      if (snapshot.value['base64_image'] != null) {
        if (kDebugMode) {
          print('🔍 getResult - Base64 image found, updating imagePath...');
        }
        updatedValue['imagePath'] = snapshot.value['base64_image'];
      }

      // is_favorite alanını doğru şekilde handle et
      if (snapshot.value['is_favorite'] != null) {
        updatedValue['is_favorite'] = snapshot.value['is_favorite'];
        if (kDebugMode) {
          print(
            '🔍 getResult - is_favorite found: ${snapshot.value['is_favorite']}',
          );
        }
      }

      if (kDebugMode) {
        print(
          '🔍 getResult - Final updatedValue imagePath: ${updatedValue['imagePath'] != null ? "Mevcut (${updatedValue['imagePath'].length} karakter)" : "Yok"}',
        );
        print(
          '🔍 getResult - Final updatedValue createdAt: ${updatedValue['createdAt']}',
        );
        print(
          '🔍 getResult - Final updatedValue created_at: ${updatedValue['created_at']}',
        );
      }

      final model = ScanResultModel.fromMap(updatedValue);

      if (kDebugMode) {
        print(
          '🔍 getResult - Final model imagePath: ${model.imagePath != null ? "Mevcut (${model.imagePath!.length} karakter)" : "Yok"}',
        );
        print('🔍 getResult - Final model createdAt: ${model.createdAt}');
      }

      return model;
    }
    return null;
  }

  /// Favori durumunu güncelle
  Future<void> updateFavoriteStatus(int key, bool isFavorite) async {
    try {
      await _store.record(key).update(await db, {'is_favorite': isFavorite});

      if (kDebugMode) {
        print('✅ Favori durumu güncellendi - ID: $key, Favori: $isFavorite');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favori durumu güncelleme hatası: $e');
      }
      rethrow;
    }
  }

  /// Favori durumunu değiştir (toggle)
  Future<void> toggleFavorite(int key) async {
    try {
      final result = await getResult(key);
      if (result != null) {
        final currentFavorite = result.isFavorite ?? false;
        await updateFavoriteStatus(key, !currentFavorite);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Favori toggle hatası: $e');
      }
      rethrow;
    }
  }

  // Sonuç silme
  Future<void> deleteResult(int key) async {
    await _store.record(key).delete(await db);
  }

  /// Veritabanını tamamen temizler (tüm kayıtları siler)
  Future<void> clearAllData() async {
    try {
      if (kDebugMode) {
        print('🧹 Veritabanı temizleme başlatılıyor...');
      }

      // Tüm kayıtları sil
      await _store.delete(await db);

      if (kDebugMode) {
        print('✅ Veritabanı tamamen temizlendi');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Veritabanı temizleme hatası: $e');
      }
    }
  }

  /// Sadece test verilerini temizler (belirli koşullara göre)
  Future<void> clearTestData() async {
    try {
      if (kDebugMode) {
        print('🧹 Test verileri temizleme başlatılıyor...');
      }

      // Test verilerini bul ve sil
      final testSnapshots = await _store.find(
        await db,
        finder: Finder(
          filter: Filter.or([
            Filter.equals('type', 'Test'),
            Filter.equals('type', 'Test Stone'),
            Filter.equals('type', 'Test Gem'),
            Filter.matches('type', 'Test'),
          ]),
        ),
      );

      if (kDebugMode) {
        print('🔍 Bulunan test kayıtları: ${testSnapshots.length}');
      }

      // Test kayıtlarını sil
      for (final snapshot in testSnapshots) {
        await _store.record(snapshot.key).delete(await db);
      }

      if (kDebugMode) {
        print('✅ Test verileri temizlendi: ${testSnapshots.length} kayıt');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Test verileri temizleme hatası: $e');
      }
    }
  }

  // Tüm verileri temizleme
  Future<void> clearAll() async {
    await _store.delete(await db);
  }

  // Veritabanını kapatma (yeni eklenen)
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
