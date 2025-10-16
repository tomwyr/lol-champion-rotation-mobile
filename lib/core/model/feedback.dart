import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class UserFeedback {
  UserFeedback({
    required this.title,
    required this.description,
  });

  static const titleMaxLength = 50;
  static const descriptionMaxLength = 1000;

  final String? title;
  final String description;

  factory UserFeedback.fromJson(Map<String, dynamic> json) => _$UserFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$UserFeedbackToJson(this);
}

enum UserFeedbackError {
  titleEmpty,
  titleTooLong,
  descriptionEmpty,
  descriptionTooLong,
}
