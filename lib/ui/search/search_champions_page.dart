import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/search_champions/search_champions_cubit.dart';
import '../../core/state.dart';
import '../../dependencies/locate.dart';
import '../common/utils/routes.dart';
import '../common/widgets/data_states.dart';
import 'search_champions_data.dart';
import 'search_champions_field.dart';

class SearchChampionsPage extends StatelessWidget {
  const SearchChampionsPage({super.key});

  static void push(BuildContext context) {
    context.pushDefaultRoute(
      BlocProvider(
        create: (_) => locateNew<SearchChampionsCubit>(),
        child: const SearchChampionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 2,
        shadowColor: Colors.black,
        title: SearchChampionsFieldHero(
          child: SearchChampionsField.input(),
        ),
      ),
      body: searchData(context),
    );
  }

  Widget searchData(BuildContext context) {
    final cubit = context.watch<SearchChampionsCubit>();

    return switch (cubit.state) {
      Initial() => const DataInfo(
          icon: Icons.manage_search,
          message: 'Start typing to search...',
        ),
      Loading() => const DataLoading(),
      Error() => const DataError(
          icon: Icons.search_off,
          message: "We couldn't retrieve the search results. Please try again later.",
        ),
      Data(:var value) => SearchChampionsData(data: value),
    };
  }
}
