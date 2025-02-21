import 'package:flutter/material.dart';

import '../../core/state.dart';
import '../../core/stores/rotation.dart';
import '../../core/stores/search_champions/search_champions.dart';
import '../../dependencies.dart';
import '../widgets/data_states.dart';
import 'search_champions_field.dart';
import 'search_champions_list.dart';

class SearchChampionsPage extends StatefulWidget {
  const SearchChampionsPage({super.key});

  @override
  State<SearchChampionsPage> createState() => _SearchChampionsPageState();
}

class _SearchChampionsPageState extends State<SearchChampionsPage> {
  final store = locate<SearchChampionsStore>();

  @override
  void initState() {
    super.initState();
    final localData = locate<RotationStore>().dataOrNull;
    store.initialize(localData);
  }

  @override
  void dispose() {
    reset<SearchChampionsStore>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            appBar(context),
            searchData(context),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      title: SearchChampionsField(),
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
        Data(:var value) => SearchChampionsList(data: value),
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
