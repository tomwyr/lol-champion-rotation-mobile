import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/rotation.dart';
import '../../dependencies.dart';
import '../app/app_notifications.dart';
import '../settings/settings_page.dart';
import '../widgets/data_error.dart';
import '../widgets/data_loading.dart';
import '../widgets/events_listener.dart';
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
      events: locate<RotationStore>().events.stream,
      onEvent: onEvent,
      child: Material(
        child: SafeArea(
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
                  appBarTrailing: const SettingsButton(),
                ),
            },
          ),
        ),
      ),
    );
  }

  void onEvent(RotationEvent event, AppNotifications notifications) {
    switch (event) {
      case RotationEvent.loadingMoreDataError:
        notifications.showError(
          message: 'Failed to load next rotation data.',
        );
    }
  }
}
