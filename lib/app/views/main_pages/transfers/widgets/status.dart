import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_icons/line_icons.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/time_line.dart';
import '/models/transfer.dart';

class TransferState extends StatefulWidget {
  const TransferState(this.transfer, {super.key});

  final TransferModel transfer;

  @override
  State<TransferState> createState() => _TransferStateState();
}

class _TransferStateState extends State<TransferState> {
  late AppLocalizations? _arb;
  late TransferModel transfer;

  IconData icon1 = LineIcons.hourglassStart;
  IconData icon2 = LineIcons.hourglassHalf;
  IconData icon3 = LineIcons.check;
  IconData icon4 = LineIcons.circle;
  Color color1 = Colors.grey;
  Color color2 = Colors.orange;
  Color color3 = Colors.green;
  Color color4 = Colors.grey;

  String status4 = '';

  @override
  void initState() {
    super.initState();
    transfer = widget.transfer;

    color4 = transfer.status.index == 4 ? MainColors.red : MainColors.color1;
    icon4 =
        transfer.status.index == 4 ? LineIcons.times : LineIcons.doubleCheck;
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    status4 = transfer.status.index == 4 ? _arb!.canceled : _arb!.completed;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, kTextTabBarHeight, 16, 0),
      children: [
        TextX(
          _arb!.transferStatus,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        TextX(
          _arb!.recentTransferUpdateStatus,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: kToolbarHeight),

        // Transfer time line process.
        TimelineWidget(
          status: transfer.status.index,
          dates: [
            transfer.addedAt.substring(0, 10),
            transfer.addedAt.substring(0, 10),
            transfer.addedAt.substring(0, 10),
            transfer.completedAt == '0000-00-00'
                ? ''
                : transfer.completedAt.substring(0, 10),
          ],
          events: {
            Icon(icon1, color: color1): _arb!.waitingPayment,
            Icon(icon2, color: color2): _arb!.awaitingProcess,
            Icon(icon3, color: color3): _arb!.processing,
            Icon(icon4, color: color4): status4,
          },
        ),
        Visibility(
          visible: transfer.adminCancelReason.isNotEmpty,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            width: MediaQuery.of(context).size.width,
            decoration: Decorations.note(context),
            child: TextX(transfer.adminCancelReason),
          ),
        ),
      ],
    );
  }
}
