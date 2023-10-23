import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/recipients/recipient/widget/icon_detail.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/dotted_border/dotted_border.dart';
import '/app/widgets/image/image_widget.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/models/transfer.dart';
import '/services/lang_service.dart';
import '/tools/attachment_tools.dart';

class TransferDetail extends StatefulWidget {
  const TransferDetail(this.transfer, {super.key});

  final TransferModel transfer;

  @override
  State<TransferDetail> createState() => _TransferDetailState();
}

class _TransferDetailState extends State<TransferDetail> {
  late AppLocalizations arb;
  late TransferModel transfer;

  double exchangeRate = 0;

  String receiveType = '';

  @override
  void initState() {
    super.initState();
    transfer = widget.transfer;

    exchangeRate = transfer.recipientAmount / transfer.sendAmount;
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;
    super.didChangeDependencies();

    receiveType = Helper.receiveType(context)[transfer.receiveType];
  }

  @override
  Widget build(BuildContext context) {
    final bool isAr = LangService.isAR();
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextX(
                arb.transferDetails,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              TextX(
                arb.transferInformationDetails,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: transfer.receiptPic.isNotEmpty ? 10 : 20),
              RowSpaceBetween([
                Expanded(
                  child: RecipientIconDetail(recipient: transfer.recipient),
                ),
                Visibility(
                  visible: transfer.receiptPic.isNotEmpty,
                  child: InkWell(
                    onTap: () => AttachmentTools.openImage(
                      context,
                      url: transfer.receiptPic,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    child: Column(
                      children: [
                        TextX(
                          arb.receipt,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        DottedBorder(
                          borderType: BorderType.rRect,
                          radius: const Radius.circular(6),
                          padding: const EdgeInsets.all(4),
                          dashPattern: const [5, 5],
                          color: Theme.of(context).dividerColor,
                          child: ImageWidget(
                            transfer.receiptPic,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            radius: 6,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ]),
              SizedBox(height: transfer.receiptPic.isNotEmpty ? 0 : 20),
              Visibility(
                visible: transfer.status.index < 3,
                child: InkWell(
                  onTap: () => Clipboard.setData(
                    ClipboardData(text: transfer.wallet.address),
                  ).whenComplete(() {
                    Helper.snack(
                      '${arb.copiedSuccessfully}\n${transfer.wallet.address}',
                    );
                  }),
                  borderRadius: BorderRadius.circular(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextX(
                        arb.walletAddress,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      DottedBorder(
                        borderType: BorderType.rRect,
                        radius: const Radius.circular(6),
                        padding: const EdgeInsets.all(4),
                        dashPattern: const [5, 5],
                        color: Theme.of(context).dividerColor,
                        child: TextC(
                          transfer.wallet.address,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: transfer.completedMessage.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: Decorations.note(context),
                  child: TextX(transfer.completedMessage),
                ),
              ),
              RowSpaceBetween([
                TextX(arb.youSent),
                Text.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${transfer.sendAmount.toStringAsFixed(2)} ',
                      ),
                      const TextSpan(text: 'USDT'),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: Decorations.note(context, radius: 0),
          child: RowSpaceBetween([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextX(
                  arb.transferDate,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                TextX(arb.exchangeRate),
                const SizedBox(height: 4),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextX(
                  transfer.addedAt.substring(0, 10),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                Text.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${isAr ? '' : '1'} USDT ${isAr ? '1 ' : ''}= ',
                      ),
                      TextSpan(
                        text: exchangeRate.toStringAsFixed(2),
                      ),
                      TextSpan(
                        text:
                            ' ${transfer.isReceiveInUsd ? 'USD' : transfer.recipient.country.currency.code}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowSpaceBetween([TextX(arb.city), TextX(transfer.city.name)]),
              RowSpaceBetween([
                TextX(arb.fee),
                Text.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${transfer.fees.toStringAsFixed(2)} ',
                      ),
                      const TextSpan(text: 'USDT'),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 4),
              if (transfer.provider.name.isNotEmpty)
                RowSpaceBetween([
                  TextX(arb.provider),
                  TextX(transfer.provider.name),
                ]),
              const HDivider(height: 40),
              RowSpaceBetween([
                TextX(arb.totalPaid),
                Text.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${transfer.totalAmount.toStringAsFixed(2)} ',
                      ),
                      const TextSpan(text: 'USDT'),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ]),
              const SizedBox(height: 4),
              RowSpaceBetween([
                TextX(arb.recipientGets),
                Text.rich(
                  textScaleFactor: 1.0,
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${transfer.recipientAmount.toStringAsFixed(2)} ',
                      ),
                      TextSpan(
                        text: transfer.isReceiveInUsd
                            ? 'USD'
                            : transfer.recipient.country.currency.code,
                      ),
                    ],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ]),
              Visibility(
                visible: transfer.provider.defaultMessage.isNotEmpty,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: Decorations.note(context),
                  child: TextX(transfer.provider.defaultMessage),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
