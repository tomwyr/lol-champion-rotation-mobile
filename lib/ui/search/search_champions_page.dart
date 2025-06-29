import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../core/state.dart';
import '../../core/stores/search_champions/search_champions_store.dart';
import '../../dependencies/locate.dart';
import '../../dependencies/scoped_key.dart';
import '../common/widgets/data_states.dart';
import 'search_champions_data.dart';
import 'search_champions_field.dart';

class SearchChampionsPage extends StatefulWidget {
  const SearchChampionsPage({super.key});

  @override
  State<SearchChampionsPage> createState() => _SearchChampionsPageState();
}

class _SearchChampionsPageState extends State<SearchChampionsPage> {
  late final SearchChampionsStore store;

  @override
  void initState() {
    super.initState();
    store = locateScoped<SearchChampionsStore>(this);
  }

  @override
  void dispose() {
    resetScoped<SearchChampionsStore>(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedKey<SearchChampionsStore>(
      value: this,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 2,
          shadowColor: Colors.black,
          title: SearchChampionsFieldHero(
            child: SearchChampionsField.input(),
          ),
        ),
        body: searchData(context),
      ),
    );
  }

  Widget searchData(BuildContext context) {
    return Observer(
      builder: (context) => switch (store.state) {
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
      },
    );
  }
}
