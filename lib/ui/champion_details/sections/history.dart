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
              ChampionDetailsHistoryRotation() => _RotationEvent(
                  type: eventType(index),
                  event: event,
                ),
              ChampionDetailsHistoryBench() => _BenchEvent(
                  type: eventType(index),
                  event: event,
                ),
              ChampionDetailsHistoryRelease() => _ReleaseEvent(
                  type: eventType(index),
                  event: event,
                ),
            }
      ],
    );
  }

  EventStepType eventType(int index) {
    return EventStepType.from(index: index, length: details.history.length);
  }
}

class _RotationEvent extends StatelessWidget {
  const _RotationEvent({
    required this.type,
    required this.event,
  });

  final EventStepType type;
  final ChampionDetailsHistoryRotation event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: EventStepStyle.filled,
      onTap: () {
        context.pushDefaultRoute(RotationDetailsPage(
          rotationId: event.id,
        ));
      },
      child: Row(
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
      ),
    );
  }
}

class _BenchEvent extends StatelessWidget {
  const _BenchEvent({
    required this.type,
    required this.event,
  });

  final EventStepType type;
  final ChampionDetailsHistoryBench event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: EventStepStyle.bullet,
      child: Text(
        '${event.rotationsMissed} rotation${event.rotationsMissed.pluralSuffix} missed',
        style: TextStyle(color: context.appTheme.descriptionColor),
      ),
    );
  }
}

class _ReleaseEvent extends StatelessWidget {
  const _ReleaseEvent({
    required this.type,
    required this.event,
  });

  final EventStepType type;
  final ChampionDetailsHistoryRelease event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: EventStepStyle.bullet,
      child: Text('Released on ${event.releasedAt.formatShortFull()}'),
    );
  }
}

class _HistoryEvent extends StatelessWidget {
  const _HistoryEvent({
    required this.type,
    required this.style,
    this.onTap,
    required this.child,
  });

  final EventStepType type;
  final EventStepStyle style;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EventStep(
      type: type,
      style: style,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      child: child,
    );
  }
}
