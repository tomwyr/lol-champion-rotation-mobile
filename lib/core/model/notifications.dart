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
