import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ThrottledCacheManager extends CacheManager with ImageCacheManager {
  ThrottledCacheManager._({required int concurrentFetches})
    : super(
        Config(
          DefaultCacheManager.key,
          fileService: ThrottledFileService(concurrentFetches: concurrentFetches),
        ),
      );

  static final shared = ThrottledCacheManager._(concurrentFetches: 5);
}

class ThrottledFileService extends HttpFileService {
  ThrottledFileService({super.httpClient, required int concurrentFetches})
    : _concurrentFetches = concurrentFetches;

  final int _concurrentFetches;

  @override
  int get concurrentFetches => _concurrentFetches;
}
