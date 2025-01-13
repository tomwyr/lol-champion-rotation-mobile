import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/model/rotation.dart';
import 'common/extensions.dart';

class RotationData extends StatefulWidget {
  const RotationData({
    super.key,
    required this.rotation,
    required this.onRefresh,
    required this.appBarTrailing,
  });

  final ChampionRotation rotation;
  final RefreshCallback onRefresh;
  final Widget appBarTrailing;

  @override
  State<RotationData> createState() => _RotationDataState();
}

class _RotationDataState extends State<RotationData> {
  var searchActive = false;
  var searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverAppBar(
              centerTitle: false,
              title: searchActive ? searchField() : title(),
              actions: [
                if (!searchActive) ...[
                  searchButton(),
                  widget.appBarTrailing,
                ],
              ],
            ),
          ),
          ChampionsSection(
            title: "Champions available for free",
            subtitle: formatDuration(),
            champions: widget.rotation.regularChampions,
            searchQuery: searchQuery,
          ),
          const SizedBox(height: 24).sliver,
          SliverSafeArea(
            top: false,
            sliver: ChampionsSection(
              title: "Champions available for free for new players",
              subtitle:
                  "New players up to level ${widget.rotation.beginnerMaxLevel} get access to a different pool of champions",
              champions: widget.rotation.beginnerChampions,
              searchQuery: searchQuery,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: 'Champion name...',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              searchQuery = "";
              searchActive = false;
            });
          },
          icon: const Icon(Icons.clear),
        ),
      ),
      onChanged: (value) {
        setState(() => searchQuery = value);
      },
    );
  }

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        setState(() => searchActive = true);
      },
      icon: const Icon(Icons.search),
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Flexible(
          child: Text('Current rotation'),
        ),
        if (widget.rotation.patchVersion case var version?) ...[
          const SizedBox(width: 8),
          Text(
            'v$version',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ],
    );
  }

  String formatDuration() {
    final formatter = DateFormat('MMMM dd');

    final duration = widget.rotation.duration;
    final start = formatter.format(duration.start);
    final end = formatter.format(duration.end);

    return '$start to $end';
  }
}

class ChampionsSection extends StatelessWidget {
  const ChampionsSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.champions,
    required this.searchQuery,
  });

  final String title;
  final String? subtitle;
  final List<Champion> champions;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final filteredChampions = filterChampions();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              if (subtitle case var subtitle?)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              const SizedBox(height: 12)
            ],
          ).sliver,
          if (filteredChampions.isEmpty)
            const Text("No champions match your search query.").sliver
          else
            championsGrid(filteredChampions)
        ],
      ),
    );
  }

  List<Champion> filterChampions() {
    final formattedQuery = searchQuery.trim().toLowerCase();
    if (formattedQuery.isEmpty) {
      return champions;
    } else {
      return champions
          .where((champion) => champion.name.toLowerCase().contains(formattedQuery))
          .toList();
    }
  }

  Widget championsGrid(List<Champion> champions) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: champions.length,
      itemBuilder: (context, index) {
        final champion = champions[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: champion.imageUrl,
          ),
        );
      },
    );
  }
}
