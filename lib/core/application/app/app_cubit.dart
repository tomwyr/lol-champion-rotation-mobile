import '../../../common/base_cubit.dart';
import '../../../data/services/app_service.dart';
import '../../state.dart';
import 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit({required this.appService}) : super(Initial());

  final AppService appService;

  void initialize() async {
    try {
      final appInfo = await appService.getAppInfo();
      emit(Data(appInfo));
    } catch (err) {
      emit(Error());
    }
  }

  Future<void> checkForUpdate() async {
    final status = await appService.checkUpdateStatus();
    if (status == .available) {
      await appService.installUpdate();
    }
  }

  void rateApp() {
    appService.openStorePage();
  }
}
