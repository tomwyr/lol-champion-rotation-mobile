import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../../common/components/rotation_summary.dart';
import '../../common/theme.dart';
import '../../common/utils/formatters.dart';
import '../../common/widgets/event_step.dart';
import '../../rotation_details/rotation_details_page.dart';
import 'section.dart';

class ChampionDetailsHistorySection extends StatelessWidget {
  const ChampionDetailsHistorySection({super.key, required this.details});

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
              ChampionDetailsHistoryBench() => _BenchEvent(type: eventType(index), event: event),
              ChampionDetailsHistoryRelease() => _ReleaseEvent(
                type: eventType(index),
                event: event,
              ),
            },
      ],
    );
  }

  EventStepType eventType(int index) {
    return .from(index: index, length: details.history.length);
  }
}

class _RotationEvent extends StatelessWidget {
  const _RotationEvent({required this.type, required this.event});

  final EventStepType type;
  final ChampionDetailsHistoryRotation event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .filled,
      onTap: () => RotationDetailsPage.push(context, rotationId: event.id),
      child: RotationSummaryTile(
        duration: event.duration,
        current: event.current,
        championImageUrls: event.championImageUrls,
      ),
    );
  }
}

class _BenchEvent extends StatelessWidget {
  const _BenchEvent({required this.type, required this.event});

  final EventStepType type;
  final ChampionDetailsHistoryBench event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .bullet,
      child: Text(
        '${event.rotationsMissed} rotation${event.rotationsMissed.pluralSuffix} missed',
        style: TextStyle(color: context.appTheme.descriptionColor),
      ),
    );
  }
}

class _ReleaseEvent extends StatelessWidget {
  const _ReleaseEvent({required this.type, required this.event});

  final EventStepType type;
  final ChampionDetailsHistoryRelease event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .bullet,
      child: Text('Released on ${event.releasedAt.formatShortFull()}'),
    );
  }
}

class _HistoryEvent extends StatelessWidget {
  const _HistoryEvent({required this.type, required this.style, this.onTap, required this.child});

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
      padding: const .symmetric(horizontal: 16),
      onTap: onTap,
      child: child,
    );
  }
}
