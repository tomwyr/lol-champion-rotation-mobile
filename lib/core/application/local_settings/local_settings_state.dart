import '../../model/local_settings.dart';

class LocalSettingsState {
  LocalSettingsState({
    required this.initialized,
    required this.settings,
  });

  factory LocalSettingsState.initial() {
    return LocalSettingsState(initialized: false, settings: LocalSettings.defaults());
  }

  factory LocalSettingsState.data(LocalSettings settings) {
    return LocalSettingsState(initialized: true, settings: settings);
  }

  final bool initialized;
  final LocalSettings settings;
}
