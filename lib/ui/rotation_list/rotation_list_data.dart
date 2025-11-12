import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/application/local_settings/local_settings_cubit.dart';
import '../../core/application/rotation/rotation_state.dart';
import '../../core/model/common.dart';
import '../../core/model/rotation.dart';
import '../common/utils/extensions.dart';
import '../common/utils/listenables.dart';
import '../common/widgets/more_data_loader.dart';
import '../common/widgets/persistent_header_delegate.dart';
import '../common/widgets/pinch_zoom.dart';
import '../common/widgets/scroll_up_button.dart';
import 'current_rotation.dart';
import 'selectors/rotation_type.dart';

class RotationListData extends StatefulWidget {
  const RotationListData({
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
  State<RotationListData> createState() => _RotationListDataState();
}

class _RotationListDataState extends State<RotationListData> {
  final scrollController = ScrollController();
  final rotationType = ValueNotifier(ChampionRotationType.regular);

  late final ChangeNotifier checkLoadMore;

  ChampionRotationsOverview get currentRotation => widget.data.rotationsOverview;
  List<ChampionRotation> get nextRotations => widget.data.nextRotations;
  bool get hasNextRotation => widget.data.hasNextRotation;

  LocalSettingsCubit get settingsCubit => context.read();
  Stream<RotationViewType> get rotationViewTypeStream {
    return settingsCubit.stream.map((state) => state.settings.rotationViewType).distinct();
  }

  @override
  void initState() {
    super.initState();
    checkLoadMore = StreamNotifier(rotationViewTypeStream);
  }

  @override
  void dispose() {
    checkLoadMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = CustomScrollView(
      controller: scrollController,
      slivers: [appBar(), rotationConfig(), rotationChampions()],
    );

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ScrollUpButton(
        controller: scrollController,
        child: Builder(
          builder: (context) {
            final rotationViewType = context.select(
              (LocalSettingsCubit cubit) => cubit.state.settings.rotationViewType,
            );
            return viewTypePinchZoom(rotationViewType, content);
          },
        ),
      ),
    );
  }

  Widget viewTypePinchZoom(RotationViewType rotationViewType, Widget child) {
    return PinchZoom(
      progress: switch (rotationViewType) {
        .loose => 1,
        .compact => 0,
      },
      onExpand: () => settingsCubit.changeRotationViewType(.loose),
      onShrink: () => settingsCubit.changeRotationViewType(.compact),
      rulerBuilder: (value) =>
          PinchZoomRuler(value: value, marksCount: 12, startLabel: '3x', endLabel: '2x'),
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
      actions: [widget.appBarTrailing],
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: .baseline,
      textBaseline: .alphabetic,
      children: [
        const Flexible(child: Text('Champion rotation')),
        if (currentRotation.patchVersion case var version?) ...[
          const SizedBox(width: 8),
          Text(
            'v$version',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: .w300),
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
          padding: const .symmetric(horizontal: 16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ValueListenableBuilder(
            valueListenable: rotationType,
            builder: (context, value, child) =>
                RotationTypePicker(value: value, onChanged: rotationType.setValue),
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
        checkLoadMore: checkLoadMore,
      ),
    );
  }
}
