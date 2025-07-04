import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';

import 'common.dart';

part 'local_settings.g.dart';

@CopyWith()
class LocalSettings {
  LocalSettings({
    required this.version,
    required this.themeMode,
    required this.rotationViewType,
    required this.predictionsEnabled,
    required this.predictionsExpanded,
  });

  factory LocalSettings.defaults() {
    return LocalSettings(
      version: '',
      themeMode: ThemeMode.system,
      rotationViewType: RotationViewType.compact,
      predictionsEnabled: false,
      predictionsExpanded: false,
    );
  }

  final String version;
  final ThemeMode themeMode;
  final RotationViewType rotationViewType;
  final bool predictionsEnabled;
  final bool predictionsExpanded;
}
