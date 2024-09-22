import 'package:flutter/material.dart';

import '../core/state.dart';
import '../core/store.dart';
import '../data/repository.dart';
import 'rotation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = RotationStore(repository: RotationRepository());

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
          Initial() || Loading() => loadingView(),
          Error() => errorView(),
          Data(:var value) => RotationView(rotation: value),
        },
      ),
    );
  }

  Widget loadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget errorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 72,
            color: Colors.black38,
          ),
          const SizedBox(height: 4),
          Text(
            'Failed to load data. Please try again.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: store.loadCurrentRotation,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
