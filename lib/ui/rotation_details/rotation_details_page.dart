import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../../core/state.dart';
import '../../core/stores/local_settings.dart';
import '../../core/stores/rotation_details.dart';
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
      child: ValueListenableBuilder(
        valueListenable: detailsStore.state,
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Rotation details'),
            actions: [
              if (value case Data(:var value))
                IconButton(
                  onPressed: !value.togglingBookmark ? detailsStore.toggleBookmark : null,
                  icon: Icon(value.rotation.observing ? Icons.bookmark : Icons.bookmark_outline),
                ),
            ],
          ),
          body: switch (value) {
            Initial() || Loading() => const DataLoading(),
            Error() => const DataError(
                message: "We couldn't retrieve the rotation data. Please try again later.",
              ),
            Data(value: var data) => ValueListenableBuilder(
                valueListenable: settingsStore.rotationViewType,
                builder: (context, value, child) => RotationSection(
                  rotation: data.rotation,
                  compact: value == RotationViewType.compact,
                ),
              ),
          },
        ),
      ),
    );
  }

  void onEvent(RotationDetailsEvent event, AppNotificationsState notifications) {
    switch (event) {
      case RotationDetailsEvent.bookmarkingFailed:
        notifications.showError(
          message: "We couldn't update the rotation bookmark. Please try again later.",
        );
    }
  }
}
