import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  UserFeedback({
    required this.title,
    required this.description,
    required this.type,
  });

  static const titleMaxLength = 50;
  static const descriptionMaxLength = 1000;

  final String? title;
  final String description;
  final UserFeedbackType? type;

  factory UserFeedback.fromJson(Map<String, dynamic> json) => _$UserFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}

enum UserFeedbackType {
  bug,
  feature,
}

enum UserFeedbackError {
  titleEmpty,
  titleTooLong,
  descriptionEmpty,
  descriptionTooLong,
}
