import 'package:get_it/get_it.dart';

T locate<T extends Object>() {
  return _locate(null);
}

T locateScoped<T extends Object>(Object key) {
  return _locate(key);
}

void resetScoped<T extends Object>(Object key) {
  final typeInstances = _scopedInstances.putIfAbsent(T, () => {});
  typeInstances.remove(key);
}

T _locate<T extends Object>(Object? key) {
  final typeInstances = _scopedInstances.putIfAbsent(T, () => {});
  final scopedInstance = typeInstances.putIfAbsent(key, GetIt.instance.get<T>);
  return scopedInstance as T;
}

final _scopedInstances = <Type, Map<Object?, Object>>{};
