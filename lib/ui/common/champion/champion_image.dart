import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/model/champion.dart';

class ChampionImageHero extends StatelessWidget {
  const ChampionImageHero({
    super.key,
    required this.champion,
    this.size,
  });

  final Champion champion;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'championImage/${champion.name}',
      child: SizedBox.square(
        dimension: size,
        child: ChampionImage(champion: champion),
      ),
    );
  }
}

class ChampionImage extends StatelessWidget {
  const ChampionImage({
    super.key,
    required this.champion,
  });

  final Champion champion;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 200),
        imageUrl: champion.imageUrl,
      ),
    );
  }
}
