import 'package:flutter/material.dart';

import '../../core/model/rotation.dart';
import '../../core/stores/rotation.dart';
import '../../dependencies.dart';
import '../app.dart';
import '../utils/extensions.dart';
import '../widgets/events_listener.dart';
import '../widgets/more_data_loader.dart';
import 'champions_section.dart';
import 'rotation_type.dart';

class RotationPage extends StatefulWidget {
  const RotationPage({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.onLoadMore,
    required this.appBarTrailing,
  });

  final RotationData data;
  final RefreshCallback onRefresh;
  final VoidCallback onLoadMore;
  final Widget appBarTrailing;

  @override
  State<RotationPage> createState() => _RotationPageState();
}

class _RotationPageState extends State<RotationPage> {
  final scrollController = ScrollController();

  var searchActive = false;
  var searchQuery = "";

  var rotationType = RotationType.regular;

  CurrentChampionRotation get currentRotation => widget.data.currentRotation;
  List<ChampionRotation> get nextRotations => widget.data.nextRotations;
  bool get hasNextRotation => widget.data.hasNextRotation;

  @override
  Widget build(BuildContext context) {
    return EventsListener(
      events: locate<RotationStore>().events.stream,
      onEvent: onEvent,
      child: CustomScrollView(
        controller: scrollController,
        slivers: applySafeArea(
          children: [
            appBar(),
            rotationTypePicker(),
            ...switch (rotationType) {
              RotationType.regular => regularChampions(),
              RotationType.beginner => beginnerChampions(),
            },
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      centerTitle: false,
      title: searchActive ? searchField() : title(),
      actions: [
        if (!searchActive) ...[
          searchButton(),
          widget.appBarTrailing,
        ],
      ],
    );
  }

  Widget searchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: 'Champion name...',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchQuery = "";
              searchActive = false;
            });
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      onChanged: (value) {
        setState(() => searchQuery = value);
      },
    );
  }

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        setState(() => searchActive = true);
      },
      icon: const Icon(Icons.search),
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Flexible(
          child: Text('Champion rotation'),
        ),
        if (currentRotation.patchVersion case var version) ...[
          const SizedBox(width: 8),
          Text(
            'v$version',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ],
    );
  }

  Widget rotationTypePicker() {
    return RotationTypePicker(
      value: rotationType,
      onChanged: (value) {
        setState(() {
          rotationType = value;
        });
      },
    );
  }

  List<Widget> regularChampions() {
    final sections =
        ChampionsSectionFactory(searchQuery).regularSections(currentRotation, nextRotations);

    if (sections.isNotEmpty) {
      return [
        ...sections,
        if (hasNextRotation) moreDataLoader(),
      ];
    } else {
      return [emptyChampionsPlaceholder()];
    }
  }

  List<Widget> beginnerChampions() {
    final section = ChampionsSectionFactory(searchQuery).beginnerSection(currentRotation);
    return [section ?? emptyChampionsPlaceholder()];
  }

  Widget emptyChampionsPlaceholder() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: Text(
        "No champions match your search query.",
        style: Theme.of(context).textTheme.bodyLarge,
      ).sliver,
    );
  }

  Widget moreDataLoader() {
    return MoreDataLoader(
      controller: scrollController,
      onLoadMore: widget.onLoadMore,
    ).sliver;
  }

  List<Widget> applySafeArea({required List<Widget> children}) {
    final [first, ...middle, last] = children;

    return [
      SliverSafeArea(
        bottom: false,
        sliver: first,
      ),
      for (var sliver in middle)
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: sliver,
        ),
      SliverSafeArea(
        top: false,
        sliver: last,
      ),
    ];
  }

  void onEvent(RotationEvent event, AppNotifications notifications) {
    switch (event) {
      case RotationEvent.loadingMoreDataError:
        notifications.showError(
          message: 'Failed to load next rotation data',
        );
    }
  }
}
