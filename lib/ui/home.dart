import 'package:flutter/material.dart';

import '../core/state.dart';
import '../core/stores/rotation.dart';
import '../dependencies.dart';
import 'rotation.dart';
import 'settings.dart';
import 'widgets/data_error.dart';
import 'widgets/data_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = locate<RotationStore>();

  @override
  void initState() {
    super.initState();
    store.loadCurrentRotation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: store.state,
          builder: (context, value, _) => switch (value) {
            Initial() || Loading() => const DataLoading(
                message: 'Loading...',
              ),
            Error() => DataError(
                message: 'Failed to load data. Please try again.',
                onRetry: store.loadCurrentRotation,
              ),
            Data(:var value) => RotationData(
                rotation: value,
                onRefresh: store.refreshCurrentRotation,
                appBarTrailing: const SettingsButton(),
              ),
          },
        ),
      ),
    );
  }
}
