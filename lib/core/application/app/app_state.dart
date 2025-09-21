import '../../../common/app_config.dart';
import '../../state.dart';

typedef AppState = DataState<AppInfo>;

class AppInfo {
  AppInfo({required this.version, required this.flavor});

  final String version;
  final AppFlavor flavor;
}
