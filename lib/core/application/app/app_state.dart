import '../../../common/app_config.dart';
import '../../../common/utils/changelog_parser.dart';
import '../../state.dart';

typedef AppState = DataState<AppData>;

class AppData {
  AppData({
    required this.name,
    required this.version,
    required this.flavor,
    required this.changelog,
  });

  final String name;
  final String version;
  final AppFlavor flavor;
  final Changelog? changelog;
}
