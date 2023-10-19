import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/transfers/widgets/detail.dart';
import '/app/views/main_pages/transfers/widgets/status.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/divider.dart';
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
  late AppLocalizations arb;

  late TransferModel transfer;

  String recipientAmount = '';

  bool isAr = false;
  bool selectedStatus = false;
  bool selectedDetail = true;

  int _pageIndex = 0;
  final PageController _pageCtrl = PageController();

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
    arb = AppLocalizations.of(context)!;
    isAr = LangService.isAR();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/splash${context.isDarkMode ? '' : '_light'}.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AutoAppBar(title: 'ID: ${transfer.id}'),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Center(child: TextX(arb.sent)),
            const SizedBox(height: 6),
            Center(
              child: TextX(
                '$recipientAmount ${transfer.isReceiveInUsd ? 'USD' : transfer.recipient.country.currency.code}',
                style: TransferMain.boldStyle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: TextX(
                '${transfer.recipient.firstName} ${transfer.recipient.lastName}',
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(14, 12, 14, 50),
                decoration: Decorations.main(context, radius: 16),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(children: [
                      _button(
                        onTap: () => setState(() {
                          selectedDetail = true;
                          selectedStatus = false;
                          _pageCtrl.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn,
                          );
                        }),
                        selected: selectedDetail,
                        title: arb.transferDetails,
                        icon: HeroIcons.receiptPercent,
                        right: isAr,
                      ),
                      _button(
                        onTap: () => setState(() {
                          selectedStatus = true;
                          selectedDetail = false;
                          _pageCtrl.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeIn,
                          );
                        }),
                        right: !isAr,
                        selected: selectedStatus,
                        title: arb.transferStatus,
                        icon: HeroIcons.presentationChartLine,
                      ),
                    ]),
                    Expanded(
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageCtrl,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) => setState(() {
                          _pageIndex = index;
                          if (_pageIndex == 0) {
                            selectedStatus = false;
                            selectedDetail = true;
                          } else {
                            selectedDetail = false;
                            selectedStatus = true;
                          }
                        }),
                        children: [
                          TransferDetail(transfer),
                          TransferState(transfer),
                        ],
                      ),
                    ),
                    Container(
                      decoration: Decorations.main(
                        context,
                        radius: 16,
                        color: MainColors.color1,
                      ),
                      child: Button(
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
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        customShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        TextX(arb.resendAgain.toUpperCase()),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required void Function()? onTap,
    required String title,
    required HeroIcons icon,
    bool right = false,
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 55,
            width: MediaQuery.of(context).size.width,
            child: Button(
              onTap,
              color: selected
                  ? MainColors.color1.withOpacity(0.05)
                  : Theme.of(context).canvasColor.withOpacity(0.4),
              customShape: TransferMain.topRadius(right: right),
              FittedBox(
                child: Row(children: [
                  HeroIcon(
                    icon,
                    color: TransferMain.iconColor(context),
                  ),
                  const SizedBox(width: 4),
                  TextX(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ]),
              ),
            ),
          ),
          Visibility(
            visible: selected,
            replacement: HDivider(
              height: 3,
              thickness: 3,
              color: Theme.of(context).canvasColor.withOpacity(0.4),
            ),
            child: const HDivider(
              height: 3,
              thickness: 3,
              color: MainColors.color1,
            ),
          ),
        ],
      ),
    );
  }
}
