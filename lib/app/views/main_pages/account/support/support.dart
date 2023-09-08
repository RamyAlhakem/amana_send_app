import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/widgets/auto_app_bar.dart';
import 'widget/support_body.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Scaffold(
      appBar: AutoAppBar(
        title: arb!.support,
        subTitle: arb.contactSupportTeam,
        titleStyle: Theme.of(context).textTheme.bodyLarge,
      ),
      body: const SupportBody(),
    );
  }
}
