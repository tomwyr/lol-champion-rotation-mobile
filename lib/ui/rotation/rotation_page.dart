import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/rotation/rotation_cubit.dart';
import '../../core/application/rotation/rotation_state.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../app/app_drawer.dart';
import '../app/app_notifications.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';
import '../common/widgets/lifecycle.dart';
import '../search/search_champions_field.dart';
import '../search/search_champions_page.dart';
import 'rotation_data.dart';

class RotationPage extends StatelessWidget {
  const RotationPage({super.key});

  static Widget withDependencies() {
    return BlocProvider(
      create: (_) => locateNew<RotationCubit>(),
      child: const RotationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RotationCubit>();

    return Lifecycle(
      onInit: cubit.loadRotationsOverview,
      child: EventsListener(
        events: cubit.events.stream,
        onEvent: onEvent,
        child: Scaffold(
          endDrawer: const AppDrawer(),
          body: SafeArea(
            bottom: false,
            child: switch (cubit.state) {
              Initial() || Loading() => const DataLoading(
                  message: 'Loading...',
                ),
              Error() => DataError(
                  message: 'Failed to load data. Please try again.',
                  onRetry: cubit.loadRotationsOverview,
                ),
              Data(:var value) => RotationDataPage(
                  data: value,
                  onRefresh: cubit.refreshRotationsOverview,
                  onLoadMore: cubit.loadNextRotation,
                  title: SearchChampionsFieldHero(
                    child: SearchChampionsField.button(
                      onTap: () => SearchChampionsPage.push(context),
                    ),
                  ),
                  appBarTrailing: const AppDrawerButton(),
                ),
            },
          ),
        ),
      ),
    );
  }

  void onEvent(RotationEvent event, AppNotificationsState notifications) {
    switch (event) {
      case RotationEvent.loadingMoreDataError:
        notifications.showError(
          message: 'Failed to load next rotation data.',
        );
      case RotationEvent.loadingPredictionError:
        notifications.showError(
          message: "Rotation prediction is unavailable right now.",
        );
    }
  }
}
