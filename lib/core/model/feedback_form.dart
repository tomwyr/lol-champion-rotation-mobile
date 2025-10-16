import 'feedback.dart';

class UserFeedbackInput {
  UserFeedbackInput({
    required this.title,
    required this.description,
  });

  factory UserFeedbackInput.normalized({
    required String title,
    required String description,
  }) {
    final trimmedTitle = title.trim();
    return UserFeedbackInput(
      title: trimmedTitle.isNotEmpty ? trimmedTitle : null,
      description: description.trim(),
    );
  }

  final String? title;
  final String description;

  UserFeedback validate() {
    final errors = _UserFeedbackValidationErrors();

    if (title case var title?) {
      if (title.isEmpty) {
        errors.title ??= UserFeedbackError.titleEmpty;
      }
      if (title.length > UserFeedback.titleMaxLength) {
        errors.title ??= UserFeedbackError.titleTooLong;
      }
    }

    if (description.isEmpty) {
      errors.description ??= UserFeedbackError.descriptionEmpty;
    }
    if (description.length > UserFeedback.descriptionMaxLength) {
      errors.description ??= UserFeedbackError.descriptionTooLong;
    }

    if (errors.buildIfAny() case var error?) {
      throw error;
    }

    return UserFeedback(title: title, description: description);
  }
}

class UserFeedbackValidationError implements Exception {
  UserFeedbackValidationError({
    required this.title,
    required this.description,
  });

  final UserFeedbackError? title;
  final UserFeedbackError? description;
}

class _UserFeedbackValidationErrors {
  UserFeedbackError? title;
  UserFeedbackError? description;

  UserFeedbackValidationError? buildIfAny() {
    if (title != null || description != null) {
      return UserFeedbackValidationError(
        title: title,
        description: description,
      );
    }
    return null;
  }
}
