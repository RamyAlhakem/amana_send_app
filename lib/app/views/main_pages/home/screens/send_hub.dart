import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/home/screens/wallet_address.dart';
import '/app/views/main_pages/home/widgets/send_form.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/dialogs/submit.dart';
import '/global/variables.dart';
import '/helper/helper.dart';
import 'check_out.dart';
import 'select_recipient.dart';

class SendHub extends StatefulWidget {
  const SendHub({super.key, this.recipient = 'false'});

  final String recipient;

  @override
  State<SendHub> createState() => _SendHubState();
}

class _SendHubState extends State<SendHub> with AutomaticKeepAliveClientMixin {
  late AppLocalizations? _arb;
  late Calculator _calculator;

  bool recipient = false;

  PageController _pageCtrl = PageController();
  int _index = 0;

  // app bar titles
  String appBarTitle = '';
  String appBarSubTitle = '';

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
    _arb = AppLocalizations.of(context);

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
    return WillPopScope(
      onWillPop: () async {
        if (_index != 2) {
          SubmitDialog(
            () => context.pop(),
            content: _arb!.areYouSureYouWantToCancelThisTransfer,
          ).show(context);
        }
        return _index != 2 ? false : true;
      },
      child: Scaffold(
        appBar: AutoAppBar(
          title: appBarTitle,
          subTitle: appBarSubTitle,
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
                    content: _arb!.areYouSureYouWantToCancelThisTransfer,
                  ).show(context)
              : null,
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
            const CheckOut(),
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
        if (!recipient) {
          appBarTitle = _arb!.chooseRecipient;
          appBarSubTitle = _arb!.chooseRecipientToContinue;
        }

        buttons = SelectRecipient.footer(context, _pageCtrl);
        break;

      case 1:
        appBarTitle = _arb!.reviewAndCheckout;
        appBarSubTitle = _arb!.reviewYourTransferDetailsToContinueCheckout;

        buttons = CheckOut.footer(context, _pageCtrl);
        break;

      case 2:
        appBarTitle = _arb!.payment;
        appBarSubTitle = _arb!.enterDebitCreditCardToContinue;

        buttons = const SizedBox.shrink();
        break;
    }
  }
}
