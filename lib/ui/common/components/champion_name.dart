import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';
import '../utils/extensions.dart';

class ChampionNameHero extends StatelessWidget {
  const ChampionNameHero({
    super.key,
    required this.champion,
    this.discriminator,
    this.decoration = ChampionNameDecoration.none,
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
    this.decoration = ChampionNameDecoration.none,
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

    child = Text(
      champion.name,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );

    if (decoration == ChampionNameDecoration.badge) {
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
        margin: const EdgeInsets.only(bottom: 4) * decorationExpansion,
        padding:
            EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 4) * decorationExpansion,
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
    final (:compact, :decoration, :startStyle, :endStyle, :animateDecoration) = _resolveProps();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final decorationExpansion = animateDecoration ? 1 - animation.value : 1.0;

        return OverflowBox(
          maxWidth: double.infinity,
          child: ChampionName(
            champion: champion,
            compact: compact,
            decoration: decoration,
            style: TextStyle.lerp(startStyle, endStyle, animation.value),
            decorationExpansion: decorationExpansion,
          ),
        );
      },
    );
  }

  _ChampionNameShuttleProps _resolveProps() {
    final fromName = (fromHeroContext.widget as Hero).child as ChampionName;
    final toName = (toHeroContext.widget as Hero).child as ChampionName;

    return (
      compact: fromName.compact ?? toName.compact,
      decoration: fromName.decoration == ChampionNameDecoration.badge ||
              toName.decoration == ChampionNameDecoration.badge
          ? ChampionNameDecoration.badge
          : ChampionNameDecoration.none,
      startStyle: switch (flightDirection) {
        HeroFlightDirection.push => fromName.style,
        HeroFlightDirection.pop => toName.style,
      },
      endStyle: switch (flightDirection) {
        HeroFlightDirection.push => toName.style,
        HeroFlightDirection.pop => fromName.style,
      },
      animateDecoration: (fromName.decoration == ChampionNameDecoration.badge) ^
          (toName.decoration == ChampionNameDecoration.badge),
    );
  }
}

typedef _ChampionNameShuttleProps = ({
  bool? compact,
  ChampionNameDecoration decoration,
  TextStyle? startStyle,
  TextStyle? endStyle,
  bool animateDecoration,
});
