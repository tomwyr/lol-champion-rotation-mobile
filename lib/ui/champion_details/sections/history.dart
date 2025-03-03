import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../../common/components/champion_image.dart';
import '../../common/components/current_badge.dart';
import '../../common/theme.dart';
import '../../common/utils/formatters.dart';
import '../../common/utils/routes.dart';
import '../../common/widgets/event_step.dart';
import '../../rotation_details/rotation_details_page.dart';
import 'section.dart';

class ChampionDetailsHistorySection extends StatelessWidget {
  const ChampionDetailsHistorySection({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return ChampionDetailsSection(
      title: 'History',
      padChildren: false,
      children: [
        if (details.history.isEmpty)
          const Text('Not events yet')
        else
          for (var (index, event) in details.history.indexed)
            switch (event) {
              ChampionDetailsHistoryRotation() => _eventStep(
                  index: index,
                  filled: true,
                  onTap: () {
                    context.pushDefaultRoute(RotationDetailsPage(
                      rotationId: event.id,
                    ));
                  },
                  child: _RotationEvent(event: event),
                ),
              ChampionDetailsHistoryBench() => _eventStep(
                  index: index,
                  filled: false,
                  onTap: null,
                  child: _BenchEvent(event: event),
                ),
            }
      ],
    );
  }

  Widget _eventStep({
    required int index,
    required bool filled,
    required VoidCallback? onTap,
    required Widget child,
  }) {
    return EventStep(
      height: 40,
      type: EventStepType.from(index: index, length: details.history.length),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      filled: filled,
      child: child,
    );
  }
}

class _RotationEvent extends StatelessWidget {
  const _RotationEvent({required this.event});

  final ChampionDetailsHistoryRotation event;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(event.duration.formatShort()),
        if (event.current) ...[
          const SizedBox(width: 8),
          const CurrentBadge(compact: true),
        ],
        Expanded(
          child: SizedBox(
            height: 24,
            child: Stack(
              children: [
                for (var (index, url) in event.championImageUrls.reversed.indexed)
                  Positioned(
                    right: index * 12,
                    child: ChampionImage(
                      url: url,
                      shape: ChampionImageShape.circle,
                      shadow: true,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BenchEvent extends StatelessWidget {
  const _BenchEvent({required this.event});

  final ChampionDetailsHistoryBench event;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${event.rotationsMissed} rotation${event.rotationsMissed.pluralSuffix} missed',
      style: TextStyle(color: context.appTheme.descriptionColor),
    );
  }
}
