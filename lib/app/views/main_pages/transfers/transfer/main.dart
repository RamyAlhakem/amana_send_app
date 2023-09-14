import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/transfers/widgets/detail.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/models/transfer.dart';
import '/services/lang_service.dart';

class TransferMain extends StatefulWidget {
  const TransferMain(this.transfer, {super.key});

  final String transfer;

  static const TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

  static iconColor(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.color;

  static RoundedRectangleBorder topRadius({bool right = false}) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: right ? Radius.zero : const Radius.circular(16),
          topRight: right ? const Radius.circular(16) : Radius.zero,
        ),
      );

  @override
  State<TransferMain> createState() => _TransferMainState();
}

class _TransferMainState extends State<TransferMain> {
  late AppLocalizations? _arb;

  late TransferModel transfer;

  String recipientAmount = '';

  bool isAr = false;
  bool selectedStatus = false;
  bool selectedDetail = true;

  @override
  void initState() {
    super.initState();
    transfer = TransferModel.fromJson(jsonDecode(widget.transfer));

    if (transfer.recipient.country.coCode == 'sy') {
      recipientAmount = transfer.recipientAmount.toStringAsFixed(0);
    } else {
      recipientAmount = transfer.recipientAmount.toStringAsFixed(2);
    }
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    isAr = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/splash2${context.isDarkMode ? '' : '_light'}.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AutoAppBar(),
        body: ListView(
          children: [
            Center(
              child: TextX(
                'ID: ${transfer.id}',
                style: TransferMain.boldStyle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: TextX(
                transfer.status.name.toUpperCase(),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 24, 10, 50),
              width: MediaQuery.of(context).size.width,
              child: TransferDetail(transfer),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          child: Row(children: [
            ExpandButton(
              () => Share.share(transfer.wallet.address),
              height: 45,
              color: Colors.transparent,
              foreground: MainColors.color2,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.share),
                const SizedBox(width: 10),
                TextX(_arb!.share.toUpperCase()),
              ]),
            ),
            const SizedBox(width: 10),
            ExpandButton(
              () {
                if (AppMetadata.get.maintenanceMode) {
                  return Helper.bannerWarning(
                    '\n${AppMetadata.get.maintenanceMessage}\n',
                  );
                }
                Provider.of<Calculator>(
                  context,
                  listen: false,
                ).recipientSend(
                  transfer.recipient,
                  transfer: transfer,
                  navigate: true,
                );
              },
              height: 45,
              TextX(_arb!.resendAgain.toUpperCase()),
            ),
          ]),
        ),
      ),
    );
  }
}
