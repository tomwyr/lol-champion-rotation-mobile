import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/app_config.dart';
import '../core/application/app/app_cubit.dart';
import '../core/application/app/app_state.dart';
import '../core/state.dart';
import 'common/theme.dart';
import 'common/utils/routes.dart';
import 'common/widgets/list_entry.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static void push(BuildContext context) {
    context.pushDefaultRoute(const AboutPage());
  }

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

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      title: 'Rate app',
      description: 'Give us your feedback and support.',
      onTap: context.read<AppCubit>().rateApp,
    );
  }
}

class AppVersionEntry extends StatelessWidget {
  const AppVersionEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;

    final AppInfo appInfo;
    if (state case Data(:var value)) {
      appInfo = value;
    } else {
      return const SizedBox.shrink();
    }

    var description = appInfo.version;
    if (appInfo.flavor == AppFlavor.development) {
      description = 'DEV $description';
    }

    return ListEntry(
      title: 'App version',
      description: description,
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
              color: context.appTheme.textColor.withValues(alpha: 0.87),
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
