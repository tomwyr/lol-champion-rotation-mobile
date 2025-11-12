import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/observed_champions/observed_champions_cubit.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import '../common/widgets/lifecycle.dart';
import 'observed_champions_data.dart';

class ObservedChampionsPage extends StatelessWidget {
  const ObservedChampionsPage({super.key});

  static void push(BuildContext context) {
    context.pushDefaultRoute(
      BlocProvider(
        create: (_) => locateNew<ObservedChampionsCubit>(),
        child: const ObservedChampionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ObservedChampionsCubit>();

    return Lifecycle(
      onInit: cubit.loadChampions,
      child: Scaffold(
        appBar: AppBar(title: const Text('Observed champions')),
        body: switch (cubit.state) {
          Initial() || Loading() => const DataLoading(),
          Error() => const DataError(
            message: "We couldn't retrieve the observed champions. Please try again later.",
          ),
          Data(:var value) => ObservedChampionsData(
            champions: value,
            onRefresh: cubit.loadChampions,
          ),
        },
      ),
    );
  }
}
