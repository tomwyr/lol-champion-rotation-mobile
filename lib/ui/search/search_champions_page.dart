import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/search_champions/search_champions.dart';
import '../../dependencies.dart';
import '../widgets/data_states.dart';
import 'search_champions_data.dart';
import 'search_champions_field.dart';

class SearchChampionsPage extends StatefulWidget {
  const SearchChampionsPage({super.key});

  @override
  State<SearchChampionsPage> createState() => _SearchChampionsPageState();
}

class _SearchChampionsPageState extends State<SearchChampionsPage> {
  final store = locate<SearchChampionsStore>();

  @override
  void dispose() {
    reset<SearchChampionsStore>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 2,
        shadowColor: Colors.black,
        title: const SearchChampionsField(),
      ),
      body: searchData(context),
    );
  }

  Widget searchData(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: store.state,
      builder: (context, value, child) => switch (value) {
        Initial() => fillBody(
            child: const DataInfo(
              icon: Icons.manage_search,
              message: 'Start typing to search...',
            ),
          ),
        Loading() => fillBody(
            child: const DataLoading(),
          ),
        Error() => fillBody(
            child: const DataError(
              icon: Icons.search_off,
              message: "We couldn't retrieve the search results. Please try again later.",
            ),
          ),
        Data(:var value) => SearchChampionsData(data: value),
      },
    );
  }

  Widget fillBody({required Widget child}) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: child,
    );
  }
}
