import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../../core/model/rotation.dart';
import '../../core/stores/app.dart';
import '../../core/stores/rotation.dart';
import '../../dependencies.dart';
import '../utils/extensions.dart';
import '../widgets/more_data_loader.dart';
import '../widgets/persistent_header_delegate.dart';
import '../widgets/pinch_zoom.dart';
import 'champions_section.dart';
import 'rotation_type.dart';
import 'rotation_view_type.dart';

class RotationDataPage extends StatefulWidget {
  const RotationDataPage({
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
  State<RotationDataPage> createState() => _RotationDataPageState();
}

class _RotationDataPageState extends State<RotationDataPage> {
  AppStore get appStore => locate();

  final scrollController = ScrollController();

  var searchActive = false;
  var searchQuery = "";
  var rotationType = RotationType.regular;

  CurrentChampionRotation get currentRotation => widget.data.currentRotation;
  List<ChampionRotation> get nextRotations => widget.data.nextRotations;
  bool get hasNextRotation => widget.data.hasNextRotation;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ValueListenableBuilder(
        valueListenable: appStore.rotationViewType,
        builder: (context, value, child) => viewTypePinchZoom(value, child!),
        child: CustomScrollView(
          controller: scrollController,
          slivers: applySafeArea(
            children: [
              appBar(),
              rotationConfig(),
              rotationChampions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewTypePinchZoom(RotationViewType rotationViewType, Widget child) {
    return PinchZoom(
      progress: switch (rotationViewType) {
        RotationViewType.loose => 1,
        RotationViewType.compact => 0,
      },
      onExpand: () => appStore.changeRotationViewType(RotationViewType.loose),
      onShrink: () => appStore.changeRotationViewType(RotationViewType.compact),
      rulerBuilder: (value) => PinchZoomRuler(
        value: value,
        marksCount: 12,
        startLabel: '3x',
        endLabel: '2x',
      ),
      child: child,
    );
  }

  Widget appBar() {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SliverAppBar(
      centerTitle: false,
      floating: true,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
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
        if (currentRotation.patchVersion case var version?) ...[
          const SizedBox(width: 8),
          Text(
            'v$version',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                ),
          ),
        ],
      ],
    );
  }

  Widget rotationConfig() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StaticPersistentHeaderDelegate(
        extent: 32,
        child: SizedBox(
          height: 32,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  RotationTypePicker(
                    value: rotationType,
                    onChanged: (value) {
                      setState(() {
                        rotationType = value;
                      });
                    },
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: appStore.rotationViewType,
                    builder: (context, value, child) => RotationViewTypePicker(
                      value: value,
                      onChanged: appStore.changeRotationViewType,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rotationChampions() {
    return ValueListenableBuilder(
      valueListenable: appStore.rotationViewType,
      builder: (context, value, child) => SliverMainAxisGroup(
        slivers: switch (rotationType) {
          RotationType.regular => regularChampions(value),
          RotationType.beginner => beginnerChampions(value),
        },
      ),
    );
  }

  List<Widget> regularChampions(RotationViewType rotationViewType) {
    final sections = ChampionsSectionFactory(
      searchQuery: searchQuery,
      compact: rotationViewType == RotationViewType.compact,
    ).regularSections(currentRotation, nextRotations);

    if (sections.isNotEmpty) {
      return [
        ...sections.gapped(vertically: 12, sliver: true),
        if (!searchActive && hasNextRotation) moreDataLoader(),
      ];
    } else {
      return [emptyChampionsPlaceholder()];
    }
  }

  List<Widget> beginnerChampions(RotationViewType rotationViewType) {
    final section = ChampionsSectionFactory(
      searchQuery: searchQuery,
      compact: rotationViewType == RotationViewType.compact,
    ).beginnerSection(currentRotation);
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
      extentThreshold: 200,
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
}
