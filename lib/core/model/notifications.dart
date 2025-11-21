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

sealed class PushNotification {
  PushNotification({required this.title, required this.body, required this.type});

  final String title;
  final String body;
  final PushNotificationType type;

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return switch (PushNotificationType.fromJson(json['type'])) {
      .rotationChanged => RotationChangedNotification.fromJson(json),
      .championsAvailable => ChampionsAvailableNotification.fromJson(json),
      .championReleased => ChampionReleasedNotification.fromJson(json),
    };
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class RotationChangedNotification extends PushNotification {
  RotationChangedNotification({required super.title, required super.body, required super.type});

  factory RotationChangedNotification.fromJson(Map<String, dynamic> json) =>
      _$RotationChangedNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RotationChangedNotificationToJson(this);
}

@JsonSerializable()
class ChampionsAvailableNotification extends PushNotification {
  ChampionsAvailableNotification({required super.title, required super.body, required super.type});

  factory ChampionsAvailableNotification.fromJson(Map<String, dynamic> json) =>
      _$ChampionsAvailableNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChampionsAvailableNotificationToJson(this);
}

@JsonSerializable()
class ChampionReleasedNotification extends PushNotification {
  ChampionReleasedNotification({
    required super.title,
    required super.body,
    required super.type,
    required this.championId,
  });

  final String championId;

  factory ChampionReleasedNotification.fromJson(Map<String, dynamic> json) =>
      _$ChampionReleasedNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChampionReleasedNotificationToJson(this);
}

enum PushNotificationType {
  rotationChanged,
  championsAvailable,
  championReleased;

  static PushNotificationType fromJson(String json) {
    return $enumDecode(_$PushNotificationTypeEnumMap, json);
  }
}

class PushNotificationEvent {
  PushNotificationEvent({required this.notification, required this.context});

  final PushNotification notification;
  final PushNotificationContext context;
}

enum PushNotificationContext { launch, background, foreground }
