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
  static const int _dbVersion = 1; // Yeni eklenen versiyon bilgisi

  // Veritabanı bağlantısı getter'ı
  Future<Database> get db async {
    return _db ??= await _initDatabase();
  }

  // Veritabanı başlatma (optimize edilmiş)
  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/gemai.db';
    return await databaseFactoryIo.openDatabase(dbPath, version: _dbVersion);
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
      // Model'i map'e çevir
      final Map<String, dynamic> data = model.toMap();

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
        print('✅ Scan result kaydedildi - ID: $id');
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
    final snapshots = await _store.find(
      await db,
      finder: Finder(sortOrders: [SortOrder('createdAt', false)]),
    );
    return snapshots.map((snap) {
      final model = ScanResultModel.fromMap(snap.value);
      // Base64 görseli varsa imagePath'e ata
      if (snap.value['base64_image'] != null) {
        return HistoryItem(
          snap.key,
          ScanResultModel(
            name: model.name,
            altName: model.altName,
            description: model.description,
            symptoms: model.symptoms,
            treatment: model.treatment,
            severityRatio: model.severityRatio,
            category: model.category,
            contagious: model.contagious,
            bodyParts: model.bodyParts,
            riskFactors: model.riskFactors,
            prevention: model.prevention,
            recoveryTime: model.recoveryTime,
            alternativeTreatments: model.alternativeTreatments,
            imagePath:
                snap.value['base64_image'] as String?, // Base64 görseli ata
            createdAt: model.createdAt,
          ),
        );
      }
      return HistoryItem(snap.key, model);
    }).toList();
  }

  // Tek bir sonuç getirme
  Future<ScanResultModel?> getResult(int key) async {
    final snapshot = await _store.record(key).getSnapshot(await db);
    if (snapshot != null) {
      final model = ScanResultModel.fromMap(snapshot.value);
      // Base64 görseli varsa imagePath'e ata
      if (snapshot.value['base64_image'] != null) {
        return ScanResultModel(
          name: model.name,
          altName: model.altName,
          description: model.description,
          symptoms: model.symptoms,
          treatment: model.treatment,
          severityRatio: model.severityRatio,
          category: model.category,
          contagious: model.contagious,
          bodyParts: model.bodyParts,
          riskFactors: model.riskFactors,
          prevention: model.prevention,
          recoveryTime: model.recoveryTime,
          alternativeTreatments: model.alternativeTreatments,
          imagePath:
              snapshot.value['base64_image'] as String?, // Base64 görseli ata
          createdAt: model.createdAt,
        );
      }
      return model;
    }
    return null;
  }

  // Sonuç silme
  Future<void> deleteResult(int key) async {
    await _store.record(key).delete(await db);
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
