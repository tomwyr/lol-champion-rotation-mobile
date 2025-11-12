import 'package:flutter/material.dart';

import '../about_page.dart';
import '../feedback_page.dart';
import '../observed_champions/observed_champions_page.dart';
import '../observed_rotations/observed_rotations_page.dart';
import '../settings/settings_page.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: 4),
      child: IconButton(
        onPressed: Scaffold.of(context).openEndDrawer,
        icon: const Icon(Icons.segment),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const _DrawerHeader(),
            _DrawerTile(
              icon: Icons.visibility_outlined,
              title: "Champions",
              onTap: () => ObservedChampionsPage.push(context),
            ),
            const _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.bookmark_border,
              title: "Rotations",
              onTap: () => ObservedRotationsPage.push(context),
            ),
            const _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.tune,
              title: "Preferences",
              onTap: () => SettingsPage.push(context),
            ),
            const _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.campaign_outlined,
              title: "Feedback",
              onTap: () => FeedbackPage.show(context),
            ),
            const _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.info_outline,
              title: "About",
              onTap: () => AboutPage.push(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        onTap();
        Scaffold.of(context).closeEndDrawer();
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(20, 24, 20, 12),
      child: Text("Menu", style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class _DrawerSeparator extends StatelessWidget {
  const _DrawerSeparator();

  @override
  Widget build(BuildContext context) {
    return const Divider(indent: 56, height: 1, thickness: 0.5);
  }
}
