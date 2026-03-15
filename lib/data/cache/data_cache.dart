import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import '../../core/model/rotation.dart';
import 'typed_store.dart';

class DataCache {
  DataCache({this.dbName = 'lol_champion_rotation.db'});

  final String dbName;

  var _initialized = false;

  late final TypedStore<ChampionRotationDetails> _rotationDetailsStore;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    final db = await _openDb();
    _rotationDetailsStore = AppTypedStore.rotationDetails(db);
  }

  Future<Database> _openDb() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final dbPath = join(dir.path, dbName);
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  Future<void> saveRotationDetails(ChampionRotationDetails rotationDetails) async {
    await _rotationDetailsStore.save(rotationDetails);
  }

  Future<ChampionRotationDetails?> loadRotationDetails(String rotationId) async {
    return await _rotationDetailsStore.load(rotationId);
  }
}

enum DataCacheError implements Exception {
  databaseNotInitialized;

  @override
  String toString() => switch (this) {
    .databaseNotInitialized =>
      'Database not initialized - call DataCache.initialize() to open it before accessing data',
  };
}
