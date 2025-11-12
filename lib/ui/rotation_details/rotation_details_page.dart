import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/rotation_details/rotation_details_cubit.dart';
import '../../core/application/rotation_details/rotation_details_state.dart';
import '../../core/model/common.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/components/champions_list.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';
import '../common/widgets/lifecycle.dart';

class RotationDetailsPage extends StatelessWidget {
  const RotationDetailsPage({
    super.key,
    required this.rotationId,
  });

  final String rotationId;

  static void push(BuildContext context, {required String rotationId}) {
    context.pushDefaultRoute(
      BlocProvider(
        create: (_) => locateNew<RotationDetailsCubit>(),
        child: RotationDetailsPage(rotationId: rotationId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RotationDetailsCubit>();

    return Lifecycle(
      onInit: () => cubit.initialize(rotationId),
      child: EventsListener(
        events: cubit.events.stream,
        onEvent: onEvent,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Rotation details'),
            actions: [
              if (cubit.state case Data(:var value))
                IconButton(
                  onPressed: !value.togglingObserved ? cubit.toggleObserved : null,
                  icon: Icon(value.rotation.observing ? Icons.bookmark : Icons.bookmark_outline),
                ),
            ],
          ),
          body: switch (cubit.state) {
            Initial() || Loading() => const DataLoading(),
            Error() => const DataError(
                message: "Failed to retrieve rotation data. Please try again later.",
              ),
            Data(value: var data) => Builder(
                builder: (context) {
                  final rotationViewType = context
                      .select((LocalSettingsCubit cubit) => cubit.state.settings.rotationViewType);
                  return SafeArea(
                    child: RotationSection(
                      rotation: data.rotation,
                      compact: rotationViewType == .compact,
                    ),
                  );
                },
              ),
          },
        ),
      ),
    );
  }

  void onEvent(RotationDetailsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case .observingFailed:
        notifications.showError(
          message: "Failed to update rotation bookmark. Please try again later.",
        );
      case .rotationObserved:
        notifications.showSuccess(
          message: "Rotation added to bookmarks",
          duration: .short,
        );
      case .rotationUnobserved:
        notifications.showSuccess(
          message: "Rotation removed from bookmarks",
          duration: .short,
        );
    }
  }
}
