import 'package:flutter_test/flutter_test.dart';
import 'package:lol_champion_rotation/core/model/feedback.dart';
import 'package:lol_champion_rotation/core/model/feedback_form.dart';

void main() {
  group('UserFeedbackInput', () {
    test('trims message whitespace', () {
      final feedback = UserFeedbackInput.normalized(
        message: '  Add sorting options  ',
        type: .feature,
      ).validate();

      expect(feedback.message, 'Add sorting options');
      expect(feedback.type, UserFeedbackType.feature);
    });

    test('rejects empty message', () {
      final input = UserFeedbackInput.normalized(message: '', type: null);

      expect(
        input.validate,
        throwsUserFeedbackError(message: .messageEmpty),
      );
    });

    test('rejects whitespace-only message', () {
      final input = UserFeedbackInput.normalized(message: '   ', type: null);

      expect(
        input.validate,
        throwsUserFeedbackError(message: .messageEmpty),
      );
    });

    test('rejects message longer than the maximum length', () {
      final input = UserFeedbackInput.normalized(
        message: 'a' * (UserFeedback.messageMaxLength + 1),
        type: null,
      );

      expect(
        input.validate,
        throwsUserFeedbackError(message: .messageTooLong),
      );
    });

    test('accepts null type', () {
      final feedback = UserFeedbackInput.normalized(message: 'Looks good', type: null).validate();

      expect(feedback.message, 'Looks good');
      expect(feedback.type, isNull);
    });
  });
}

Matcher throwsUserFeedbackError({UserFeedbackError? message}) => throwsA(
  isA<UserFeedbackValidationError>().having((error) => error.message, 'message', message),
);
