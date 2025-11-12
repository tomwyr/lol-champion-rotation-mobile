import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/application/feedback/feedback_cubit.dart';
import '../core/application/feedback/feedback_state.dart';
import '../core/model/feedback.dart';
import '../core/model/feedback_form.dart';
import '../dependencies/locate.dart';
import 'app/app_notifications.dart';
import 'common/utils/routes.dart';
import 'common/widgets/app_bottom_sheet.dart';
import 'common/widgets/bottom_sheet/bottom_sheet_dismiss_guard.dart';
import 'common/widgets/events_listener.dart';
import 'common/widgets/limit_left_counter.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  static void show(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      builder: (_) =>
          BlocProvider(create: (_) => locateNew<FeedbackCubit>(), child: const FeedbackPage()),
    );
  }

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  UserFeedbackType? _selectedType;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      confirmDismiss: context.select((FeedbackCubit cubit) => cubit.state is! Initial),
      confirmDismissData: _confirmDismissData(),
      child: EventsListener(
        events: context.read<FeedbackCubit>().events.stream,
        onEvent: (event, notifications) => _onEvent(context, event, notifications),
        child: _feedbackForm(),
      ),
    );
  }

  BottomSheetDismissGuardData _confirmDismissData() {
    return const BottomSheetDismissGuardData(
      title: "Disacrd Feedback",
      description: "You haven't submitted your feedback yet. Discard anyway?",
      confirmLabel: "Discard",
    );
  }

  Widget _feedbackForm() {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        _header(),
        const SizedBox(height: 12),
        _titleInput(),
        _titleTrailingSpacer(),
        _descriptionInput(),
        _descriptionTrailingSpacer(),
        _typeInput(),
        const SizedBox(height: 16),
        _submitButton(),
      ],
    );
  }

  void _onEvent(BuildContext context, FeedbackEvent event, AppNotificationsState notifications) {
    switch (event) {
      case .feedbackSubmitted:
        context.pop();
        notifications.showSuccess(message: 'Feedback sent. Thank you!');

      case .submittingFailed:
        notifications.showError(message: 'Could not submit feedback. Please try again.');
    }
  }

  Widget _header() {
    return Text('Feedback', style: Theme.of(context).textTheme.headlineMedium);
  }

  Widget _titleInput() {
    return Builder(
      builder: (context) {
        final loading = context.selectLoading();
        final error = context.selectInputError((error) => error.title);

        return TextField(
          controller: _titleController,
          onChanged: (_) => _onInputChanged(),
          readOnly: loading,
          autofocus: true,
          maxLines: 1,
          maxLength: UserFeedback.titleMaxLength,
          textCapitalization: .sentences,
          textInputAction: .next,
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: 'Add ability to…',
            floatingLabelBehavior: .always,
            errorText: error?.displayMessage,
          ),
          buildCounter: LimitLeftCounter(showAtCharactersLeft: 10).build,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        );
      },
    );
  }

  Widget _titleTrailingSpacer() {
    return LimitLeftVisibilitySpacer(
      controller: _titleController,
      maxLength: UserFeedback.titleMaxLength,
      showAtCharactersLeft: 10,
      height: 8,
    );
  }

  Widget _descriptionInput() {
    return Builder(
      builder: (context) {
        final loading = context.selectLoading();
        final error = context.selectInputError((error) => error.description);

        return TextField(
          controller: _descriptionController,
          onChanged: (_) => _onInputChanged(),
          readOnly: loading,
          minLines: 5,
          maxLines: null,
          maxLength: UserFeedback.descriptionMaxLength,
          textCapitalization: .sentences,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'I want it to be so that…',
            floatingLabelBehavior: .always,
            errorText: error?.displayMessage,
          ),
          buildCounter: LimitLeftCounter(showAtCharactersLeft: 100).build,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        );
      },
    );
  }

  Widget _descriptionTrailingSpacer() {
    return LimitLeftVisibilitySpacer(
      controller: _descriptionController,
      maxLength: UserFeedback.descriptionMaxLength,
      showAtCharactersLeft: 100,
      height: 8,
    );
  }

  Widget _typeInput() {
    return DropdownButtonFormField<UserFeedbackType?>(
      initialValue: _selectedType,
      onChanged: (value) {
        _selectedType = value;
        _onInputChanged();
      },
      decoration: const InputDecoration(labelText: 'Type', floatingLabelBehavior: .always),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text('None', style: TextStyle(color: Theme.of(context).hintColor)),
        ),
        for (var type in UserFeedbackType.values)
          DropdownMenuItem(value: type, child: Text(type.displayName)),
      ],
    );
  }

  Widget _submitButton() {
    return Builder(
      builder: (context) {
        final loading = context.selectLoading();
        final canSubmit = context.selectCanSubmit();

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canSubmit ? _onSubmit : null,
            child: !loading
                ? const Text('Submit')
                : const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
          ),
        );
      },
    );
  }

  void _onInputChanged() {
    context.read<FeedbackCubit>().onInputChanged(_collectInput());
  }

  void _onSubmit() {
    context.read<FeedbackCubit>().submit(_collectInput());
  }

  UserFeedbackInput _collectInput() {
    return .normalized(
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
    );
  }
}

extension on BuildContext {
  bool selectLoading() {
    return select((FeedbackCubit cubit) => cubit.state is Submitting);
  }

  bool selectCanSubmit() {
    return select(
      (FeedbackCubit cubit) => switch (cubit.state) {
        InputInvalid(:var triedToSubmit) => !triedToSubmit,
        _ => true,
      },
    );
  }

  UserFeedbackError? selectInputError(
    UserFeedbackError? Function(UserFeedbackValidationError error) selectError,
  ) {
    return select(
      (FeedbackCubit cubit) => switch (cubit.state) {
        InputInvalid(:var error, triedToSubmit: true) => selectError(error),
        _ => null,
      },
    );
  }
}

extension on UserFeedbackError {
  String get displayMessage {
    return switch (this) {
      .titleEmpty => 'Title cannot be empty.',
      .titleTooLong => 'Title must be at most ${UserFeedback.titleMaxLength} characters.',
      .descriptionEmpty => 'Description cannot be empty.',
      .descriptionTooLong =>
        'Description must be at most ${UserFeedback.descriptionMaxLength} characters.',
    };
  }
}

extension on UserFeedbackType {
  String get displayName {
    return switch (this) {
      .bug => 'Bug',
      .feature => 'Feature',
    };
  }
}
