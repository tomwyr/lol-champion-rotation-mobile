import 'dart:async';

import '../../../common/base_cubit.dart';
import '../../../data/api_client.dart';
import '../../model/feedback.dart';
import '../../model/feedback_form.dart';
import 'feedback_state.dart';

class FeedbackCubit extends BaseCubit<FeedbackState> {
  FeedbackCubit({required this.apiClient}) : super(Initial());

  final AppApiClient apiClient;

  final StreamController<FeedbackEvent> events = .broadcast();

  var _triedToSubmit = false;

  void onInputChanged(UserFeedbackInput input) {
    _validateFeedback(input);
  }

  void submit(UserFeedbackInput input) async {
    _triedToSubmit = true;

    switch (state) {
      case Initial() || InputInvalid(triedToSubmit: false) || InputValid():
        break;
      case Submitting():
        return;
      case InputInvalid(triedToSubmit: true):
        throw StateError('Cannot submit user feedback with invalid state more than once');
    }

    if (_validateFeedback(input) case var feedback?) {
      await _submitFeedback(feedback);
    }
  }

  UserFeedback? _validateFeedback(UserFeedbackInput input) {
    try {
      final feedback = input.validate();
      emit(InputValid());
      return feedback;
    } on UserFeedbackValidationError catch (error) {
      emit(InputInvalid(error: error, triedToSubmit: _triedToSubmit));
      return null;
    }
  }

  Future<void> _submitFeedback(UserFeedback feedback) async {
    final initialState = state;
    try {
      emit(Submitting());
      await apiClient.addFeedback(feedback);
      events.add(.feedbackSubmitted);
    } catch (_) {
      events.add(.submittingFailed);
      emit(initialState);
    }
  }
}
