import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '../../theme/colors/main_colors.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/shimmer/shimmer_load.dart';
import '/app/widgets/text/text_x.dart';
import '/graphql/api/get_notifications.dart';
import '/graphql/api/notifications_seen.dart';
import 'provider/notifications_state.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late AppLocalizations? _arb;

  @override
  void initState() {
    super.initState();

    NotificationsSeen.request().whenComplete(
      () => GetNotifications.request(),
    );
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutoAppBar(
        title: _arb!.notifications,
        bGColor: Theme.of(context).cardColor,
      ),
      body: Consumer<NotificationsState>(builder: (_, state, child) {
        child = Visibility(
          visible: !state.isLoading,
          replacement: ListView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              children: const [
                ShimmerLoad(height: 80, verticalCount: 8),
              ]),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
            itemCount: state.notifications.length,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                margin: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                decoration: BoxDecoration(
                  boxShadow: [
                    if (!context.isDarkMode)
                      BoxShadow(
                        color: const Color(0xff5e5d5d).withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                  ],
                ),
                child: Button(
                  () {},
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: MainColors.color1.withOpacity(0.05),
                          border: Border.all(color: MainColors.color1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const HeroIcon(
                          HeroIcons.bell,
                          color: MainColors.color1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextX(
                              state.notifications[i].addedAt,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextX(
                              state.notifications[i].title,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextX(
                              state.notifications[i].message,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        return child;
      }),
    );
  }
}
