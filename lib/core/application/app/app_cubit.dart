import '../../../common/base_cubit.dart';
import '../../../common/utils/changelog_parser.dart';
import '../../../data/services/app_service.dart';
import '../../state.dart';
import 'app_state.dart';

class AppCubit extends BaseCubit<AppState> {
  AppCubit({required this.appService}) : super(Initial());

  final AppService appService;

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
    } catch (_) {
      // Add logging to Sentry or similar.
      return null;
    }
  }
}
