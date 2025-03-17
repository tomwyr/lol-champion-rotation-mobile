import 'package:flutter/material.dart';

import '../core/stores/app_store.dart';
import '../core/stores/local_settings.dart';
import '../dependencies/locate.dart';
import 'common/widgets/list_entry.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            RatePromptEntry(),
            LicensesEntry(),
            AppVersionEntry(),
            Spacer(),
            RiotPolicyInfo(),
          ],
        ),
      ),
    );
  }
}

class RatePromptEntry extends StatelessWidget {
  const RatePromptEntry({super.key});

  AppStoreStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'Rate app',
      description: 'Give us your feedback and support.',
      onTap: store.rateApp,
    );
  }
}

class AppVersionEntry extends StatelessWidget {
  const AppVersionEntry({super.key});

  LocalSettingsStore get store => locate();

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'App version',
      description: store.version.value,
    );
  }
}

class LicensesEntry extends StatelessWidget {
  const LicensesEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'Licenses',
      description: 'Open source libraries and licenses.',
      trailing: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () {
        showLicensePage(context: context);
      },
    );
  }
}

class RiotPolicyInfo extends StatelessWidget {
  const RiotPolicyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        "LoL Champion Rotation isn't endorsed by Riot Games and doesn't reflect "
        "the views or opinions of Riot Games or anyone officially involved in producing "
        "or managing Riot Games properties. Riot Games, and all associated properties "
        "are trademarks or registered trademarks of Riot Games, Inc.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
