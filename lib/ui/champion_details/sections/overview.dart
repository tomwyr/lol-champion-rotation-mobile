import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../../common/theme.dart';
import '../../common/utils/extensions.dart';
import '../../common/utils/formatters.dart';
import 'section.dart';

class ChampionDetailsOverviewSection extends StatelessWidget {
  const ChampionDetailsOverviewSection({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return ChampionDetailsSection(
      title: 'Overview',
      children: [
        _occurrences(),
        _popularity(),
        _currentStreak(),
      ].gapped(vertically: 8),
    );
  }

  Widget _occurrences() {
    final value = details.overview.occurrences;
    return _Item(
      icon: Icons.tag,
      label: Text.rich([
        value.toString().spanBold,
        ' time${value.pluralSuffix} in rotation'.span,
      ].span),
    );
  }

  Widget _popularity() {
    final value = details.overview.popularity;
    return _Item(
      icon: Icons.bar_chart,
      label: switch (value) {
        null => const Text('N/A'),
        _ => Text.rich([
            value.formatOrdinal().spanBold,
            ' most popular'.span,
          ].span),
      },
    );
  }

  Widget _currentStreak() {
    final value = details.overview.currentStreak;
    return _Item(
      icon: switch (value) {
        null => Icons.trending_flat,
        > 0 => Icons.trending_up,
        < 0 => Icons.trending_down,
        _ => Icons.trending_flat,
      },
      label: switch (value) {
        null => const Text('N/A'),
        > 0 => Text.rich([
            value.abs().toString().spanBold,
            ' last rotation${value.pluralSuffix} featured'.span,
          ].span),
        < 0 => Text.rich([
            value.abs().toString().spanBold,
            ' last rotation${value.pluralSuffix} missed'.span,
          ].span),
        _ => const Text('Not featured yet'),
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Icon(
            icon,
            color: context.appTheme.iconColorDim,
          ),
        ),
        const SizedBox(width: 12),
        label,
      ],
    );
  }
}

extension on String {
  InlineSpan get span {
    return TextSpan(text: this);
  }

  InlineSpan get spanBold {
    return TextSpan(
      text: this,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

extension on List<InlineSpan> {
  InlineSpan get span {
    return TextSpan(children: this);
  }
}
