import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '/app/views/main_pages/recipients/recipient/widget/icon_detail.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/models/transfer.dart';
import '/router/app_route.dart';
import '/tools/tools.dart';

class TransferRecent extends StatelessWidget {
  const TransferRecent(this.transfer, {super.key});

  final TransferModel transfer;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? arb = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Button(
        () => context.pushNamed(
          AppRoute.transfer,
          pathParameters: <String, String>{'transfer': jsonEncode(transfer)},
        ),
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        RowSpaceBetween([
          Flexible(
            child: RecipientIconDetail(
              recipient: transfer.recipient,
              date: transfer.addedAt,
              isTransfer: true,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextX(
                  '${arb!.transferId} #${transfer.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 2),
                TextX(
                  Tools.transferStatus(transfer.status.index),
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
                        text: '${Tools.nicePrice(transfer.recipientAmount)} ',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      TextSpan(
                        text: transfer.isReceiveInUsd
                            ? 'USD'
                            : transfer.recipient.country.currency.code,
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
