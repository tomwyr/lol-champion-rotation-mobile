import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notifications.g.dart';

@JsonSerializable()
class NotificationsTokenInput {
  NotificationsTokenInput({
    required this.deviceId,
    required this.token,
  });

  final String deviceId;
  final String token;

  factory NotificationsTokenInput.fromJson(Map<String, dynamic> json) =>
      _$NotificationsTokenInputFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsTokenInputToJson(this);
}

@CopyWith()
@JsonSerializable()
class NotificationsSettings {
  NotificationsSettings({
    required this.enabled,
  });

  final bool enabled;

  factory NotificationsSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsSettingsToJson(this);
}
