import 'package:flutter/material.dart';

import '../../core/model/common.dart';
import '../../core/model/rotation.dart';
import '../../core/stores/app.dart';
import '../../core/stores/rotation.dart';
import '../../dependencies/locate.dart';
import '../common/utils/extensions.dart';
import '../common/widgets/more_data_loader.dart';
import '../common/widgets/persistent_header_delegate.dart';
import '../common/widgets/pinch_zoom.dart';
import 'current_rotation.dart';
import 'selectors/rotation_type.dart';
import 'selectors/rotation_view_type.dart';

class RotationDataPage extends StatefulWidget {
  const RotationDataPage({
    super.key,
    required this.data,
    required this.onRefresh,
    required this.onLoadMore,
    required this.title,
    required this.appBarTrailing,
  });

  final RotationData data;
  final RefreshCallback onRefresh;
  final VoidCallback onLoadMore;
  final Widget title;
  final Widget appBarTrailing;

  @override
  State<RotationDataPage> createState() => _RotationDataPageState();
}

class _RotationDataPageState extends State<RotationDataPage> {
  AppStore get appStore => locate();

  final scrollController = ScrollController();
  final rotationType = ValueNotifier(ChampionRotationType.regular);

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
          slivers: [
            appBar(),
            rotationConfig(),
            rotationChampions(),
          ],
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
      floating: true,
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
      title: widget.title,
      actions: [
        widget.appBarTrailing,
      ],
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
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              ValueListenableBuilder(
                valueListenable: rotationType,
                builder: (context, value, child) => RotationTypePicker(
                  value: value,
                  onChanged: rotationType.setValue,
                ),
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: appStore.rotationViewType,
                builder: (context, value, child) => RotationViewTypePicker(
                  value: value,
                  onChanged: appStore.changeRotationViewType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rotationChampions() {
    return ValueListenableBuilder(
      valueListenable: rotationType,
      builder: (context, value, child) => CurrentRotationList(
        data: widget.data,
        rotationType: value,
        moreDataLoader: moreDataLoader(),
      ),
    );
  }

  Widget moreDataLoader() {
    return SliverToBoxAdapter(
      child: MoreDataLoader(
        controller: scrollController,
        onLoadMore: widget.onLoadMore,
        extentThreshold: 200,
        checkLoadMore: appStore.rotationViewType,
      ),
    );
  }
}
