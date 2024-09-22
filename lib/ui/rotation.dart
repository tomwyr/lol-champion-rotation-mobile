import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/model.dart';
import 'extensions.dart';

class RotationView extends StatefulWidget {
  const RotationView({
    super.key,
    required this.rotation,
  });

  final ChampionRotation rotation;

  @override
  State<RotationView> createState() => _RotationViewState();
}

class _RotationViewState extends State<RotationView> {
  var searchActive = false;
  var searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          bottom: false,
          sliver: SliverAppBar(
            centerTitle: false,
            title: searchActive ? searchField() : const Text('Current champion rotation'),
            actions: [
              if (!searchActive) searchButton(),
            ],
          ),
        ),
        ChampionsSection(
          title: "Champions available for free",
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
              if (subtitle case var subtitle?)
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
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
