import 'package:copy_with_extension/copy_with_extension.dart';

import '../../../common/app_config.dart';
import '../../model/local_settings.dart';

part 'local_settings_state.g.dart';

@CopyWith()
class LocalSettingsState {
  LocalSettingsState({
    required this.initialized,
    required this.appVersion,
    required this.appFlavor,
    required this.settings,
  });

  factory LocalSettingsState.initial() {
    return LocalSettingsState(
      initialized: false,
      appVersion: null,
      appFlavor: null,
      settings: LocalSettings.defaults(),
    );
  }

  factory LocalSettingsState.data(String appVersion, AppFlavor appFlavor, LocalSettings settings) {
    return LocalSettingsState(
      initialized: true,
      appVersion: appVersion,
      appFlavor: appFlavor,
      settings: settings,
    );
  }

  final bool initialized;
  final String? appVersion;
  final AppFlavor? appFlavor;
  final LocalSettings settings;
}
