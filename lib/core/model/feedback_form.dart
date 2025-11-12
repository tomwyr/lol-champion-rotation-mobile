import 'feedback.dart';

class UserFeedbackInput {
  UserFeedbackInput({required this.title, required this.description, required this.type});

  factory UserFeedbackInput.normalized({
    required String title,
    required String description,
    required UserFeedbackType? type,
  }) {
    final trimmedTitle = title.trim();
    return UserFeedbackInput(
      title: trimmedTitle.isNotEmpty ? trimmedTitle : null,
      description: description.trim(),
      type: type,
    );
  }

  final String? title;
  final String description;
  final UserFeedbackType? type;

  UserFeedback validate() {
    final errors = _UserFeedbackValidationErrors();

    if (title case var title?) {
      if (title.isEmpty) {
        errors.title ??= .titleEmpty;
      }
      if (title.length > UserFeedback.titleMaxLength) {
        errors.title ??= .titleTooLong;
      }
    }

    if (description.isEmpty) {
      errors.description ??= .descriptionEmpty;
    }
    if (description.length > UserFeedback.descriptionMaxLength) {
      errors.description ??= .descriptionTooLong;
    }

    if (errors.buildIfAny() case var error?) {
      throw error;
    }

    return UserFeedback(title: title, description: description, type: type);
  }
}

class UserFeedbackValidationError implements Exception {
  UserFeedbackValidationError({required this.title, required this.description});

  final UserFeedbackError? title;
  final UserFeedbackError? description;
}

class _UserFeedbackValidationErrors {
  UserFeedbackError? title;
  UserFeedbackError? description;

  UserFeedbackValidationError? buildIfAny() {
    if (title != null || description != null) {
      return UserFeedbackValidationError(title: title, description: description);
    }
    return null;
  }
}
