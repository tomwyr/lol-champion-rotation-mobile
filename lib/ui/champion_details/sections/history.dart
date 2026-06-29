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
                modifiers: eventModifiers(index),
                event: event,
              ),
              ChampionDetailsHistoryBench() => _BenchEvent(
                type: eventType(index),
                modifiers: eventModifiers(index),
                event: event,
              ),
              ChampionDetailsHistoryRelease() => _ReleaseEvent(
                type: eventType(index),
                modifiers: eventModifiers(index),
                event: event,
              ),
              ChampionDetailsHistoryYearChanged() => _YearChangedEvent(
                type: eventType(index),
                modifiers: eventModifiers(index),
                event: event,
              ),
              ChampionDetailsHistoryGap() => _GapEvent(
                type: eventType(index),
              ),
            },
      ],
    );
  }

  EventStepType eventType(int index) {
    return .from(index: index, length: details.history.length);
  }

  EventStepModifiers eventModifiers(int index) {
    final hasPreviousGap = index > 0 && details.history[index - 1] is ChampionDetailsHistoryGap;
    final hasNextGap =
        index < details.history.length - 1 &&
        details.history[index + 1] is ChampionDetailsHistoryGap;

    return EventStepModifiers(
      shortenTopLink: hasPreviousGap,
      capTopLink: hasPreviousGap,
      shortenBottomLink: hasNextGap,
      capBottomLink: hasNextGap,
    );
  }
}

class _RotationEvent extends StatelessWidget {
  const _RotationEvent({
    required this.type,
    required this.modifiers,
    required this.event,
  });

  final EventStepType type;
  final EventStepModifiers modifiers;
  final ChampionDetailsHistoryRotation event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .filled,
      modifiers: modifiers,
      indicatorColor: event.current ? context.appTheme.availableColor : null,
      onTap: () => RotationDetailsPage.push(context, rotationId: event.id),
      child: RotationSummaryTile(
        duration: event.duration,
        current: event.current,
        championImageUrls: event.championImageUrls,
        formatYear: false,
      ),
    );
  }
}

class _BenchEvent extends StatelessWidget {
  const _BenchEvent({
    required this.type,
    required this.modifiers,
    required this.event,
  });

  final EventStepType type;
  final EventStepModifiers modifiers;
  final ChampionDetailsHistoryBench event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .bullet,
      modifiers: modifiers,
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
    required this.modifiers,
    required this.event,
  });

  final EventStepType type;
  final EventStepModifiers modifiers;
  final ChampionDetailsHistoryRelease event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .bullet,
      modifiers: modifiers,
      child: Text('Released on ${event.releasedAt.formatShortFull()}'),
    );
  }
}

class _GapEvent extends StatelessWidget {
  const _GapEvent({required this.type});

  final EventStepType type;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .gap,
      modifiers: .none,
      height: 18,
      child: _HistoryEventDivider(text: 'Not tracked'),
    );
  }
}

class _YearChangedEvent extends StatelessWidget {
  const _YearChangedEvent({
    required this.type,
    required this.modifiers,
    required this.event,
  });

  final EventStepType type;
  final EventStepModifiers modifiers;
  final ChampionDetailsHistoryYearChanged event;

  @override
  Widget build(BuildContext context) {
    return _HistoryEvent(
      type: type,
      style: .line,
      modifiers: modifiers,
      height: 24,
      child: _HistoryEventDivider(text: '${event.year}'),
    );
  }
}

class _HistoryEvent extends StatelessWidget {
  const _HistoryEvent({
    required this.type,
    required this.style,
    required this.modifiers,
    this.height = 40,
    this.indicatorColor,
    this.onTap,
    this.child,
  });

  final EventStepType type;
  final EventStepStyle style;
  final EventStepModifiers modifiers;
  final double height;
  final Color? indicatorColor;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return EventStep(
      type: type,
      style: style,
      modifiers: modifiers,
      height: height,
      indicatorColor: indicatorColor,
      padding: const .symmetric(horizontal: 16),
      onTap: onTap,
      body: child,
    );
  }
}

class _HistoryEventDivider extends StatelessWidget {
  const _HistoryEventDivider({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: context.appTheme.descriptionColor),
        ),
        SizedBox(width: 8),
        Expanded(child: Divider()),
        SizedBox(width: 96),
      ],
    );
  }
}
