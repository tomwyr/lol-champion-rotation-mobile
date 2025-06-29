import 'package:mobx/mobx.dart';

import '../../data/services/app_store_service.dart';

part 'app_store_store.g.dart';

class AppStoreStore extends _AppStoreStore with _$AppStoreStore {
  AppStoreStore({required super.updateService});
}

abstract class _AppStoreStore with Store {
  _AppStoreStore({
    required this.updateService,
  });

  final AppStoreService updateService;

  @action
  Future<void> checkForUpdate() async {
    final status = await updateService.checkUpdateStatus();
    if (status == UpdateStatus.available) {
      await updateService.installUpdate();
    }
  }

  @action
  void rateApp() {
    updateService.openStorePage();
  }
}
