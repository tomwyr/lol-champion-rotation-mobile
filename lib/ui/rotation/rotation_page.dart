import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/rotation.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';
import '../search/search_champions_field.dart';
import '../search/search_champions_page.dart';
import '../settings/settings_page.dart';
import 'rotation_data.dart';

class RotationPage extends StatefulWidget {
  const RotationPage({super.key});

  @override
  State<RotationPage> createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  final store = locate<RotationStore>();

  @override
  void initState() {
    super.initState();
    store.loadCurrentRotation();
  }

  @override
  Widget build(BuildContext context) {
    return EventsListener(
      events: store.events.stream,
      onEvent: onEvent,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: ValueListenableBuilder(
            valueListenable: store.state,
            builder: (context, value, _) => switch (value) {
              Initial() || Loading() => const DataLoading(
                  message: 'Loading...',
                ),
              Error() => DataError(
                  message: 'Failed to load data. Please try again.',
                  onRetry: store.loadCurrentRotation,
                ),
              Data(:var value) => RotationDataPage(
                  data: value,
                  onRefresh: store.refreshCurrentRotation,
                  onLoadMore: store.loadNextRotation,
                  title: SearchChampionsFieldHero(
                    child: SearchChampionsField.button(
                      onTap: () {
                        context.pushDefaultRoute(const SearchChampionsPage());
                      },
                    ),
                  ),
                  appBarTrailing: const SettingsButton(),
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
