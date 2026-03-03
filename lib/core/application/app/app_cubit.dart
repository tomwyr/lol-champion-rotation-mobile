import '../../../common/base_cubit.dart';
import '../../../common/utils/changelog_parser.dart';
import '../../../data/services/app_service.dart';
import '../../../data/services/error_service.dart';
import '../../state.dart';
import 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit({required this.appService, required this.errorService}) : super(Initial());

  final AppService appService;
  final ErrorService errorService;

  void initialize() async {
    try {
      final appInfo = await appService.getAppInfo();
      final changelog = await _tryLoadChangelog();
      final data = AppData(
        name: 'LoL Champion Rotation',
        version: appInfo.version,
        flavor: appInfo.flavor,
        changelog: changelog,
      );
      emit(Data(data));
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

  Future<Changelog?> _tryLoadChangelog() async {
    try {
      return await appService.getAppChangelog();
    } catch (error, stackTrace) {
      errorService.reportWarning('Loading application changelog failed', error, stackTrace);
      return null;
    }
  }
}
