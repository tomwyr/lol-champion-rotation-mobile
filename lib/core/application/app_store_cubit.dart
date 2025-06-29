import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/app_store_service.dart';

class AppStoreCubit extends Cubit {
  AppStoreCubit({
    required this.updateService,
  }) : super(null);

  final AppStoreService updateService;

  Future<void> checkForUpdate() async {
    final status = await updateService.checkUpdateStatus();
    if (status == UpdateStatus.available) {
      await updateService.installUpdate();
    }
  }

  void rateApp() {
    updateService.openStorePage();
  }
}
