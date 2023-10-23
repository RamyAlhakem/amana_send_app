import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/home/screens/wallet_address.dart';
import '/app/views/main_pages/home/widgets/send_form.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/transfers/provider/transfers_state.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/submit.dart';
import '/app/widgets/text/text_x.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import 'check_out_details.dart';
import 'select_recipient.dart';

class SendHub extends StatefulWidget {
  const SendHub({super.key, this.recipient = 'false'});

  final String recipient;

  @override
  State<SendHub> createState() => _SendHubState();
}

class _SendHubState extends State<SendHub> with AutomaticKeepAliveClientMixin {
  late AppLocalizations arb;
  late Calculator _calculator;

  bool recipient = false;

  PageController _pageCtrl = PageController();
  int _index = 0;

  // app bar titles
  String appBarTitle = '';

  // bottom navigation bar
  Widget buttons = const SizedBox();

  @override
  void initState() {
    super.initState();
    _calculator = Provider.of<Calculator>(context, listen: false);
    _pageCtrl = PageController(initialPage: _index);

    if (widget.recipient != 'false') recipient = true;
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context)!;

    if (appBarTitle.isEmpty) _switchState(_index);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _calculator.clearRecipient();
    Global.snackKey.currentState?.hideCurrentMaterialBanner();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final transfer = context.watch<TransfersState>().transfer;
    return WillPopScope(
      onWillPop: () async {
        if (_index != 2) {
          SubmitDialog(
            () => context.pop(),
            content: arb.areYouSureYouWantToCancelThisTransfer,
          ).show(context);
        }
        return _index != 2 ? false : true;
      },
      child: Scaffold(
        appBar: AutoAppBar(
          title: appBarTitle,
          bGColor: MainColors.color1,
          iconColor: Colors.white,
          titleStyle: const TextStyle(color: Colors.white, fontSize: 15),
          subTitleStyle: const TextStyle(color: Colors.white70, fontSize: 11),
          flexibleSpace: const SizedBox(),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Global.brightnessLight(),
            statusBarIconBrightness: Global.brightnessLight(),
          ),
          onPressed: _index != 2
              ? () => SubmitDialog(
                    () => context.pop(),
                    content: arb.areYouSureYouWantToCancelThisTransfer,
                  ).show(context)
              : null,
          actions: [
            InkWell(
              onTap: () => Helper.launchURL(AppMetadata.get.paymentTutorialUrl),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _index == 2
                    ? [
                        TextX(
                          arb.howToPay,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.info_outlined, color: Colors.white),
                        const SizedBox(width: 15),
                      ]
                    : <Widget>[],
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageCtrl,
          onPageChanged: (int page) => setState(() {
            _index = page;
            _switchState(_index);
          }),
          children: <Widget>[
            GestureDetector(
              onTap: () => Helper.unFocusCursor(context),
              child: Visibility(
                visible: !recipient,
                replacement: const SingleChildScrollView(
                  padding: EdgeInsets.all(12.0),
                  child: SendFormFields(keepAlive: true),
                ),
                child: const SelectRecipient(),
              ),
            ),
            const CheckOutDetails(),
            const WalletAddress(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: buttons,
        ),
      ),
    );
  }

  void _switchState(int index) {
    switch (index) {
      case 0:
        if (!recipient) appBarTitle = arb.chooseRecipient;

        buttons = SelectRecipient.footer(context, _pageCtrl);
        break;

      case 1:
        appBarTitle = arb.reviewSendingInfo.toUpperCase();

        buttons = CheckOutDetails.footer(context, _pageCtrl);
        break;

      case 2:
        appBarTitle = arb.payment;

        buttons = const SizedBox.shrink();
        break;
    }
  }
}
