import '../../data/services/app_store_service.dart';

class AppStoreStore {
  AppStoreStore({
    required this.updateService,
  });

  final AppStoreService updateService;

  void checkForUpdate() async {
    final status = await updateService.checkUpdateStatus();
    if (status == UpdateStatus.available) {
      await updateService.installUpdate();
    }
  }

  void rateApp() {
    updateService.openStorePage();
  }
}
