import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/model/common.dart';
import '../../core/state.dart';
import '../../core/stores/local_settings_store.dart';
import '../../core/stores/rotation_details/rotation_details_state.dart';
import '../../core/stores/rotation_details/rotation_details_store.dart';
import '../../dependencies/locate.dart';
import '../app/app_notifications.dart';
import '../common/components/champions_list.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/events_listener.dart';

class RotationDetailsPage extends StatefulWidget {
  const RotationDetailsPage({
    super.key,
    required this.rotationId,
  });

  final String rotationId;

  @override
  State<RotationDetailsPage> createState() => _RotationDetailsPageState();
}

class _RotationDetailsPageState extends State<RotationDetailsPage> {
  final settingsStore = locate<LocalSettingsStore>();

  late final RotationDetailsStore detailsStore;

  @override
  void initState() {
    super.initState();
    detailsStore = locateScoped(this);
    detailsStore.initialize(widget.rotationId);
  }

  @override
  void dispose() {
    resetScoped<RotationDetailsStore>(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EventsListener(
      events: detailsStore.events.stream,
      onEvent: onEvent,
      child: Observer(
        builder: (context) {
          final state = detailsStore.state;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Rotation details'),
              actions: [
                if (state case Data(:var value))
                  IconButton(
                    onPressed: !value.togglingObserved ? detailsStore.toggleObserved : null,
                    icon: Icon(value.rotation.observing ? Icons.bookmark : Icons.bookmark_outline),
                  ),
              ],
            ),
            body: switch (state) {
              Initial() || Loading() => const DataLoading(),
              Error() => const DataError(
                  message: "Failed to retrieve rotation data. Please try again later.",
                ),
              Data(value: var data) => Observer(
                  builder: (context) {
                    final viewType = settingsStore.rotationViewType;
                    return SafeArea(
                      child: RotationSection(
                        rotation: data.rotation,
                        compact: viewType == RotationViewType.compact,
                      ),
                    );
                  },
                ),
            },
          );
        },
      ),
    );
  }

  void onEvent(RotationDetailsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case RotationDetailsEvent.observingFailed:
        notifications.showError(
          message: "Failed to update rotation bookmark. Please try again later.",
        );
      case RotationDetailsEvent.rotationObserved:
        notifications.showSuccess(
          message: "Rotation added to bookmarks",
          duration: AppNotificationDuration.short,
        );
      case RotationDetailsEvent.rotationUnobserved:
        notifications.showSuccess(
          message: "Rotation removed from bookmarks",
          duration: AppNotificationDuration.short,
        );
    }
  }
}
