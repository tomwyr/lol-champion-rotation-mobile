import 'package:flutter/material.dart';

import '../app_config.dart';
import '../core/state.dart';
import '../core/store.dart';
import '../data/repository.dart';
import 'rotation.dart';
import 'widgets/data_error.dart';
import 'widgets/data_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = RotationStore(
    repository: RotationRepository(
      baseUrl: AppConfig.fromEnv().apiBaseUrl,
    ),
  );

  @override
  void initState() {
    super.initState();
    store.loadCurrentRotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: store.state,
        builder: (context, value, _) => switch (value) {
          Initial() || Loading() => const DataLoading(),
          Error() => DataError(onRetry: store.loadCurrentRotation),
          Data(:var value) => RotationView(
              rotation: value,
              onRefresh: store.refreshCurrentRotation,
            ),
        },
      ),
    );
  }
}
