import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  UserFeedback({required this.message, required this.type});

  static const messageMaxLength = 1000;

  final String message;
  final UserFeedbackType? type;

  factory UserFeedback.fromJson(Map<String, dynamic> json) => _$UserFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}

enum UserFeedbackType { bug, feature }

enum UserFeedbackError { messageEmpty, messageTooLong }
