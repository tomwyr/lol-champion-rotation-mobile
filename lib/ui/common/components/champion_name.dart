import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../utils/extensions.dart';

class ChampionNameHero extends StatelessWidget {
  const ChampionNameHero({
    super.key,
    required this.champion,
    this.discriminator,
    this.decoration = .none,
    this.style,
    this.compact,
    this.decorationExpansion = 1,
  });

  final ChampionSummary champion;
  final Object? discriminator;
  final ChampionNameDecoration decoration;
  final TextStyle? style;
  final bool? compact;
  final double decorationExpansion;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'championName/${champion.name}/$discriminator',
      flightShuttleBuilder: (_, animation, flightDirection, fromHeroContext, toHeroContext) {
        return _ChampionNameShuttle(
          champion: champion,
          animation: animation,
          flightDirection: flightDirection,
          fromHeroContext: fromHeroContext,
          toHeroContext: toHeroContext,
        );
      },
      child: ChampionName(
        champion: champion,
        decoration: decoration,
        style: style,
        compact: compact,
        decorationExpansion: decorationExpansion,
      ),
    );
  }
}

enum ChampionNameDecoration { none, badge }

class ChampionName extends StatelessWidget {
  const ChampionName({
    super.key,
    required this.champion,
    this.decoration = .none,
    this.style,
    this.compact,
    this.decorationExpansion = 1,
  });

  final ChampionSummary champion;
  final ChampionNameDecoration decoration;
  final TextStyle? style;
  final bool? compact;
  final double decorationExpansion;

  @override
  Widget build(BuildContext context) {
    Widget child;

    child = Text(champion.name, textAlign: .center, maxLines: 1, overflow: .ellipsis, style: style);

    if (decoration == .badge) {
      final paddingHorizontal = compact ?? false ? 8.0 : 12.0;

      final decoration = ShapeDecoration(
        color: Colors.black54.withAlphaMultipliedBy(decorationExpansion),
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 2,
            color: Colors.black38.withAlphaMultipliedBy(decorationExpansion),
          ),
        ],
      );

      child = Container(
        margin: .only(bottom: 4 * decorationExpansion),
        padding: .symmetric(
          horizontal: paddingHorizontal * decorationExpansion,
          vertical: 4 * decorationExpansion,
        ),
        decoration: decoration,
        child: child,
      );
    }

    return child;
  }
}

class _ChampionNameShuttle extends StatelessWidget {
  const _ChampionNameShuttle({
    required this.champion,
    required this.animation,
    required this.flightDirection,
    required this.fromHeroContext,
    required this.toHeroContext,
  });

  final ChampionSummary champion;
  final Animation<double> animation;
  final HeroFlightDirection flightDirection;
  final BuildContext fromHeroContext;
  final BuildContext toHeroContext;

  @override
  Widget build(BuildContext context) {
    final (:compact, :decoration, :startStyle, :endStyle, :decorationExpansion) = _resolveProps();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => OverflowBox(
        maxWidth: double.infinity,
        child: ChampionName(
          champion: champion,
          compact: compact,
          decoration: decoration,
          style: .lerp(startStyle, endStyle, animation.value),
          decorationExpansion: decorationExpansion(animation),
        ),
      ),
    );
  }

  _ChampionNameShuttleProps _resolveProps() {
    final fromName = (fromHeroContext.widget as Hero).child as ChampionName;
    final toName = (toHeroContext.widget as Hero).child as ChampionName;

    return (
      compact: fromName.compact ?? toName.compact,
      decoration: fromName.decoration == .badge || toName.decoration == .badge ? .badge : .none,
      startStyle: switch (flightDirection) {
        .push => fromName.style,
        .pop => toName.style,
      },
      endStyle: switch (flightDirection) {
        .push => toName.style,
        .pop => fromName.style,
      },
      decorationExpansion: (animation) {
        return switch ((fromName.decoration, toName.decoration)) {
          (.badge, .badge) => 0.0,
          (.badge, .none) => switch (flightDirection) {
            .push => 1.0 - animation.value,
            .pop => animation.value,
          },
          (.none, .badge) => switch (flightDirection) {
            .push => animation.value,
            .pop => 1.0 - animation.value,
          },
          (.none, .none) => 1.0,
        };
      },
    );
  }
}

typedef _ChampionNameShuttleProps = ({
  bool? compact,
  ChampionNameDecoration decoration,
  TextStyle? startStyle,
  TextStyle? endStyle,
  double Function(Animation<double> animation) decorationExpansion,
});
