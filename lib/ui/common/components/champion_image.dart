import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';

class ChampionImageHero extends StatelessWidget {
  const ChampionImageHero({
    super.key,
    required this.champion,
    this.shape = ChampionImageShape.rrect,
    this.size,
  });

  final Champion champion;
  final ChampionImageShape shape;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'championImage/${champion.name}',
      child: ChampionImage(
        url: champion.imageUrl,
        shape: shape,
        size: size,
      ),
    );
  }
}

enum ChampionImageShape { rrect, circle }

class ChampionImage extends StatelessWidget {
  const ChampionImage({
    super.key,
    required this.url,
    this.shape = ChampionImageShape.rrect,
    this.shadow = false,
    this.size,
  });

  final String url;
  final ChampionImageShape shape;
  final bool shadow;
  final double? size;

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      fadeInDuration: const Duration(milliseconds: 200),
      imageUrl: url,
    );

    child = switch (shape) {
      ChampionImageShape.rrect => _rrect(child),
      ChampionImageShape.circle => _circle(child),
    };

    return SizedBox.square(
      dimension: size,
      child: child,
    );
  }

  Widget _rrect(Widget child) {
    child = ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    );

    if (shadow) {
      child = _shadow(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        child: child,
      );
    }

    return child;
  }

  Widget _circle(Widget child) {
    child = ClipOval(
      child: child,
    );

    if (shadow) {
      child = _shadow(
        shape: BoxShape.circle,
        child: child,
      );
    }

    return child;
  }

  Widget _shadow({
    required BoxShape shape,
    BorderRadius? borderRadius,
    required Widget child,
  }) {
    return PhysicalModel(
      color: Colors.transparent,
      shadowColor: Colors.black,
      elevation: 2.0,
      shape: shape,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
