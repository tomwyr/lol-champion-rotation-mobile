import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/observed_rotations/observed_rotations_cubit.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/lifecycle.dart';
import 'observed_rotations_data.dart';

class ObservedRotationsPage extends StatelessWidget {
  const ObservedRotationsPage({super.key});

  static void push(BuildContext context) {
    context.pushDefaultRoute(
      BlocProvider(
        create: (_) => locateNew<ObservedRotationsCubit>(),
        child: const ObservedRotationsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ObservedRotationsCubit>();

    return Lifecycle(
      onInit: cubit.loadRotations,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarked rotations'),
        ),
        body: switch (cubit.state) {
          Initial() || Loading() => const DataLoading(),
          Error() => const DataError(
              message: "We couldn't retrieve the rotations bookmarks. Please try again later.",
            ),
          Data(:var value) => ObservedRotationsData(
              rotations: value,
              onRefresh: cubit.loadRotations,
            ),
        },
      ),
    );
  }
}
