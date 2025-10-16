import '../../model/feedback_form.dart';

sealed class FeedbackState {}

class Initial extends FeedbackState {}

class InputInvalid extends FeedbackState {
  InputInvalid({
    required this.error,
    required this.triedToSubmit,
  });

  final UserFeedbackValidationError error;
  final bool triedToSubmit;
}

class InputValid extends FeedbackState {}

class Submitting extends FeedbackState {}

enum FeedbackEvent {
  feedbackSubmitted,
  submittingFailed,
}
