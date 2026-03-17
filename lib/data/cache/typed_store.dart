import 'package:sembast/sembast_io.dart';

import '../../core/model/champion.dart';
import '../../core/model/rotation.dart';
import '../../core/model/rotations_data.dart';

class TypedStore<T> {
  TypedStore({
    required this.db,
    required this.name,
    required this.fromJson,
    required this.toJson,
    required this.keyOf,
  });

  final Database db;
  final String name;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T object) toJson;
  final String Function(T object) keyOf;

  late final _store = stringMapStoreFactory.store(name);

  Future<void> save(T object) async {
    await _store.record(keyOf(object)).put(db, toJson(object));
  }

  Future<T?> load(String key) async {
    final value = await _store.record(key).get(db);
    return value != null ? fromJson(value) : null;
  }
}

class AppTypedStore {
  static TypedStore<RotationsData> rotationsData(Database db, {required String key}) {
    return TypedStore(
      db: db,
      name: 'rotations-data',
      fromJson: RotationsData.fromJson,
      toJson: (object) => object.toJson(),
      keyOf: (object) => key,
    );
  }

  static TypedStore<ChampionRotationDetails> rotationDetails(Database db) {
    return TypedStore(
      db: db,
      name: 'rotation-details',
      fromJson: ChampionRotationDetails.fromJson,
      toJson: (object) => object.toJson(),
      keyOf: (object) => object.id,
    );
  }

  static TypedStore<ChampionDetails> championDetails(Database db) {
    return TypedStore(
      db: db,
      name: 'champion-details',
      fromJson: ChampionDetails.fromJson,
      toJson: (object) => object.toJson(),
      keyOf: (object) => object.id,
    );
  }
}
