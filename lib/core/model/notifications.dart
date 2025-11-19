import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notifications.g.dart';

@JsonSerializable()
class NotificationsTokenInput {
  NotificationsTokenInput({required this.token});

  final String token;

  factory NotificationsTokenInput.fromJson(Map<String, dynamic> json) =>
      _$NotificationsTokenInputFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsTokenInputToJson(this);
}

@CopyWith()
@JsonSerializable()
class NotificationsSettings {
  NotificationsSettings({
    required this.rotationChanged,
    required this.championsAvailable,
    required this.championReleased,
  });

  final bool rotationChanged;
  final bool championsAvailable;
  final bool championReleased;

  factory NotificationsSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsSettingsToJson(this);
}

@JsonSerializable()
class PushNotification {
  PushNotification({required this.type});

  final PushNotificationType type;

  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}

enum PushNotificationType { rotationChanged, championsAvailable, championReleased }
