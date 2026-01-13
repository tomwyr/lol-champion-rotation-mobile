import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/app_assets.dart';
import '../common/utils/changelog_parser.dart';
import '../core/application/app/app_state.dart';
import 'common/widgets/app_bottom_sheet.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key, required this.data});

  final AppData data;

  static Future<void> show(BuildContext context, {required AppData appData}) async {
    await AppBottomSheet.show(
      context: context,
      builder: (context) => AppInfoPage(data: appData),
    );
  }

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  var _expandChangelog = false;

  @override
  Widget build(BuildContext context) {
    final changelog = widget.data.changelog;
    final header = _AppInfoHeader(data: widget.data);

    return switch (changelog?.releases) {
      null || [] => AppBottomSheet(header: header),

      [var newest, ..._] when !_expandChangelog => AppBottomSheet(
        header: header,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            _NewestReleaseItem(release: newest),
            _showAllButton(),
          ],
        ),
      ),

      var releases => AppBottomSheet.scrollable(
        header: header,
        itemCount: releases.length,
        itemBuilder: (context, index) {
          final release = releases[index];
          return index == 0
              ? _NewestReleaseItem(release: release)
              : _HistoryReleaseItem(release: release);
        },
      ),
    };
  }

  Widget _showAllButton() {
    return Padding(
      padding: .symmetric(vertical: 8),
      child: TextButton(
        onPressed: () {
          setState(() => _expandChangelog = true);
        },
        child: Text('Show Full History'),
      ),
    );
  }
}

class _AppInfoHeader extends StatelessWidget {
  const _AppInfoHeader({required this.data});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 12),
        Image.asset(AppAssets.imageAppLogo, width: 64, height: 64),
        const SizedBox(height: 8),
        Text(data.name, style: textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(data.version, style: textTheme.titleMedium),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _NewestReleaseItem extends StatelessWidget {
  const _NewestReleaseItem({required this.release});

  final ChangelogRelease release;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("What's New", style: textTheme.titleMedium),
        const SizedBox(height: 4),
        for (var change in release.changes) Text('• $change', style: textTheme.bodyMedium),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _HistoryReleaseItem extends StatelessWidget {
  const _HistoryReleaseItem({required this.release});

  final ChangelogRelease release;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const .only(top: 12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(release.version, style: textTheme.labelLarge?.copyWith(fontWeight: .bold)),
          Text(
            dateFormat.format(release.date),
            style: textTheme.labelMedium?.copyWith(fontWeight: .w300),
          ),
          SizedBox(height: 2),
          for (var change in release.changes) Text('• $change'),
        ],
      ),
    );
  }
}
