import 'feedback.dart';

class UserFeedbackInput {
  UserFeedbackInput({required this.message, required this.type});

  factory UserFeedbackInput.normalized({
    required String message,
    required UserFeedbackType? type,
  }) {
    return UserFeedbackInput(message: message.trim(), type: type);
  }

  final String message;
  final UserFeedbackType? type;

  UserFeedback validate() {
    final errors = _UserFeedbackValidationErrors();

    if (message.isEmpty) {
      errors.message ??= .messageEmpty;
    }
    if (message.length > UserFeedback.messageMaxLength) {
      errors.message ??= .messageTooLong;
    }

    if (errors.buildIfAny() case var error?) {
      throw error;
    }

    return UserFeedback(message: message, type: type);
  }
}

class UserFeedbackValidationError implements Exception {
  UserFeedbackValidationError({required this.message});

  final UserFeedbackError? message;
}

class _UserFeedbackValidationErrors {
  UserFeedbackError? message;

  UserFeedbackValidationError? buildIfAny() {
    if (message != null) {
      return UserFeedbackValidationError(message: message);
    }
    return null;
  }
}
