import 'package:flutter/material.dart';

import '../common/utils/routes.dart';
import '../rotation_bookmarks/rotation_bookmarks_page.dart';

class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        onPressed: Scaffold.of(context).openEndDrawer,
        icon: const Icon(Icons.account_circle_outlined),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          _DrawerHeader(),
          _DrawerTile(
            icon: Icons.bookmark_border,
            title: "Rotations",
            target: RotationBookmarksPage(),
          ),
        ],
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
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
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
        "More",
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
