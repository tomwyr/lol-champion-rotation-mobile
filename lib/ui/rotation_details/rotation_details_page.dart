import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../../core/state.dart';
import '../../core/stores/app.dart';
import '../../core/stores/rotation_details.dart';
import '../../dependencies/locate.dart';
import '../common/components/champions_list.dart';
import '../common/widgets/data_states.dart';

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
  final appStore = locate<AppStore>();

  late final RotationDetailsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped(this);
    store.initialize(widget.rotationId);
  }

  @override
  void dispose() {
    resetScoped<RotationDetailsStore>(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rotation details'),
      ),
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, value, child) => switch (value) {
          Initial() || Loading() => const DataLoading(),
          Error() => const DataError(
              message: "We couldn't retrieve the rotation data. Please try again later.",
            ),
          Data(value: var rotation) => ValueListenableBuilder(
              valueListenable: appStore.rotationViewType,
              builder: (context, value, child) => RotationSection(
                rotation: rotation,
                compact: value == RotationViewType.compact,
              ),
            ),
        },
      ),
    );
  }
}
