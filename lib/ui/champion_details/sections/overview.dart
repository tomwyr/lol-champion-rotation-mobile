import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../../common/theme.dart';
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
      ],
    );
  }

  Widget _occurrences() {
    final value = details.overview.occurrences;
    return _Item(
      icon: Icons.tag,
      value: value.toString(),
      label: 'time${value.pluralSuffix} in rotation',
    );
  }

  Widget _popularity() {
    final value = details.overview.popularity;
    return _Item(
      icon: Icons.bar_chart,
      value: value.formatOrdinal(),
      label: 'most popular',
    );
  }

  Widget _currentStreak() {
    final value = details.overview.currentStreak;
    return _Item(
      icon: switch (value) {
        > 0 => Icons.trending_up,
        < 0 => Icons.trending_down,
        _ => Icons.trending_flat,
      },
      value: value != 0 ? value.abs().toString() : null,
      label: switch (value) {
        > 0 => 'last rotation${value.pluralSuffix} featured',
        < 0 => 'last rotation${value.pluralSuffix} missed',
        _ => 'Not yet featured',
      },
    );
  }
}

extension on int {
  String get pluralSuffix {
    return this != 1 && this != -1 ? 's' : '';
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String? value;
  final String label;

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
        if (value case var value?) ...[
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
        ],
        Text(label),
      ],
    );
  }
}
