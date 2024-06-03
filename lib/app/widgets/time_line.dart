import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../theme/colors/main_colors.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({
    super.key,
    required this.status,
    required this.dates,
    required this.events,
  });

  final int status;
  final List<String> dates;
  final Map<Icon, String> events;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < events.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Text(status >= i ? dates[i] : ''),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status >= i
                            ? MainColors.color2
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    if (i != events.length - 1)
                      Container(
                        height: 40,
                        width: 3,
                        color: status >= i
                            ? MainColors.color2
                            : Theme.of(context).dividerColor,
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 5,
                  child: Row(children: [
                    events.entries.toList()[i].key,
                    const SizedBox(width: 4),
                    Text(events.entries.toList()[i].value),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
