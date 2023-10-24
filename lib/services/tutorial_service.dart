import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/global/variables.dart';
import '/services/lang_service.dart';

class Tutorial {
  const Tutorial(this.context);
  final BuildContext context;

  static late AppLocalizations arb;
  static GlobalKey key1 = GlobalKey(), key2 = GlobalKey(), key3 = GlobalKey();
  static GlobalKey key4 = GlobalKey(), key5 = GlobalKey(), key6 = GlobalKey();
  static GlobalKey key7 = GlobalKey();
  static const TextStyle _style = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 20.0,
  );

  Widget _lorem() {
    return const Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  List<TargetFocus> targetSendForm() {
    if (!Global.appSettings.isFreshUser) return <TargetFocus>[];
    arb = AppLocalizations.of(context)!;
    final bool isAR = LangService.isAR();
    final List<TargetFocus> targets = <TargetFocus>[];
    targets.add(
      TargetFocus(
        identify: 'Target 1',
        keyTarget: key1,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        contents: [
          TargetContent(
            align: isAR ? ContentAlign.left : ContentAlign.right,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(arb.selectTheCountryYouWantToTransferTo, style: _style),
                _lorem(),
              ],
            ),
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'Target 2',
        keyTarget: key2,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        contents: [
          TargetContent(
            align: isAR ? ContentAlign.right : ContentAlign.left,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(arb.selectTheReceivingCity, style: _style),
                _lorem(),
              ],
            ),
          ),
          TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Multiples content',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'Target 3',
        keyTarget: key3,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        paddingFocus: 30,
        contents: [
          TargetContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  arb.knowTheCurrentExchangeRateAndChooseYourPreferredAgent,
                  style: _style,
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'Target 4',
        keyTarget: key4,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        paddingFocus: 0,
        contents: [
          TargetContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  arb.enterTheAmountYouWantToTransferInTheUSDTWhichIsEqualToTheValueOfTheUSDollar,
                  style: _style,
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'Target 5',
        keyTarget: key5,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        paddingFocus: 0,
        contents: [
          TargetContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  arb.theAmountRequiredToBeTransferredInYourLocalCurrencyIsApproximatelyBasedOnTheCurrentExchangeRate,
                  style: _style,
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'Target 6',
        keyTarget: key6,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        paddingFocus: 0,
        contents: [
          TargetContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  arb.theAmountTheRecipientWillReceiveDependsOnTheExchangeRateOfTheSelectedAgent,
                  style: _style,
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'Target 7',
        keyTarget: key7,
        shape: ShapeLightFocus.RRect,
        radius: 4,
        paddingFocus: 0,
        contents: [
          TargetContent(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  arb.afterCompletingTheTransferInformationClickHereToSpecifyTheNameOfTheRecipientAndPayTheAmount,
                  style: _style,
                ),
                _lorem(),
              ],
            ),
          ),
        ],
      ),
    );
    return targets;
  }

  void showTutorial(List<TargetFocus> targets) {
    if (!Global.appSettings.isFreshUser) return;
    arb = AppLocalizations.of(context)!;
    TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      // alignSkip: Alignment.bottomRight,
      // textSkip: 'SKIP',
      paddingFocus: 10,
      textSkip: arb.skip,
      textStyleSkip: _style,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        debugPrint('$target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        debugPrint('target: $target');
        debugPrint(
          'clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}',
        );
      },
      onClickOverlay: (target) {
        debugPrint('$target');
      },
      onSkip: () {
        debugPrint('skip');
        return true;
      },
      onFinish: () {
        debugPrint('finish');
      },
    ).show(context: context);
  }
}
