import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '/app/views/main_pages/recipients/recipient/widget/icon_detail.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/models/transfer.dart';
import '/router/app_route.dart';
import '/tools/tools.dart';

class TransferRecent extends StatefulWidget {
  const TransferRecent(this.transfer, {super.key});

  final TransferModel transfer;

  static String status(BuildContext context, int i) {
    final AppLocalizations? arb = AppLocalizations.of(context);

    String status = '';
    switch (i) {
      case 0:
        status = arb!.waitingPayment;
        break;
      case 1:
        status = arb!.processing;
        break;
      case 2:
        status = arb!.processed;
        break;
      case 3:
        status = arb!.completed;
        break;
      case 4:
        status = arb!.canceled;
        break;
      case 5:
        status = arb!.dispute;
        break;
    }
    return status;
  }

  @override
  State<TransferRecent> createState() => _TransferRecentState();
}

class _TransferRecentState extends State<TransferRecent> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TransferRecent.status(context, widget.transfer.status.index);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Button(
        () => context.pushNamed(
          AppRoute.transfer,
          pathParameters: <String, String>{
            'transfer': jsonEncode(widget.transfer),
          },
        ),
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        RowSpaceBetween([
          Flexible(
            child: RecipientIconDetail(
              recipient: widget.transfer.recipient,
              date: widget.transfer.addedAt,
              isTransfer: true,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextX(
                  '${arb!.transferId} #${widget.transfer.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 2),
                TextX(
                  TransferRecent.status(context, widget.transfer.status.index),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  textScaler: TextScaler.noScaling,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${Tools.nicePrice(widget.transfer.recipientAmount)} ',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      TextSpan(
                        text: widget.transfer.isReceiveInUsd
                            ? 'USD'
                            : widget.transfer.recipient.country.currency.code,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
