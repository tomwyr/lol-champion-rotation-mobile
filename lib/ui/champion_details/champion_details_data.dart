import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/model/champion.dart';
import '../common/theme.dart';
import '../common/widgets/utils/assets.dart';

class ChampionDetailsData extends StatelessWidget {
  const ChampionDetailsData({
    super.key,
    required this.details,
  });

  final ChampionDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox.square(
                        dimension: 96,
                        child: CachedNetworkImage(imageUrl: details.imageUrl),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            details.title,
                            style: const TextStyle(
                              height: 0.75,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (_subtitleAvailability() case var availability?) ...[
                            const SizedBox(height: 4),
                            DefaultTextStyle(
                              style: Theme.of(context).textTheme.bodyLarge!,
                              child: _buildDescription(context, availability),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      'Rotations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    ...[
                      for (var availability in details.rotationsAvailability)
                        Row(
                          children: [
                            SizedBox.square(
                              dimension: 32,
                              child: Image.asset(availability.rotationType.imageAsset),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  availability.rotationType.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                _buildDescription(context, availability),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, ChampionDetailsAvailability availability) {
    if (availability.current) {
      return Text(
        'Available',
        style: TextStyle(color: context.appTheme.availableColor),
      );
    }
    if (availability.lastAvailable case var lastAvailable?) {
      final formattedDate = DateFormat('MMM dd').format(lastAvailable);
      return Text('Last available $formattedDate');
    }
    return Text(
      'Unavailable',
      style: TextStyle(color: context.appTheme.unavailableColor),
    );
  }

  ChampionDetailsAvailability? _subtitleAvailability() {
    final sorted = details.rotationsAvailability.toList();
    sorted.sort((lhs, rhs) {
      if (lhs.current && !rhs.current) return -1;
      if (!lhs.current && rhs.current) return 1;

      if (lhs.lastAvailable == null && rhs.lastAvailable == null) return 0;
      if (rhs.lastAvailable == null) return -1;
      if (lhs.lastAvailable == null) return 1;
      return -lhs.lastAvailable!.compareTo(rhs.lastAvailable!);
    });
    return sorted.firstOrNull;
  }
}
