import 'package:flutter/material.dart';

import '../about_page.dart';
import '../common/utils/routes.dart';
import '../observed_champions/observed_champions_page.dart';
import '../observed_rotations/observed_rotations_page.dart';
import '../settings/settings_page.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
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
          children: const [
            _DrawerHeader(),
            _DrawerTile(
              icon: Icons.visibility_outlined,
              title: "Champions",
              target: ObservedChampionsPage(),
            ),
            _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.bookmark_border,
              title: "Rotations",
              target: ObservedRotationsPage(),
            ),
            _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.tune,
              title: "Preferences",
              target: SettingsPage(),
            ),
            _DrawerSeparator(),
            _DrawerTile(
              icon: Icons.info_outline,
              title: "About",
              target: AboutPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.target,
  });

  final IconData icon;
  final String title;
  final Widget target;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.pushDefaultRoute(target);
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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        "Menu",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

class _DrawerSeparator extends StatelessWidget {
  const _DrawerSeparator();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 56,
      height: 1,
      thickness: 0.5,
    );
  }
}
