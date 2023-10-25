import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/app/extensions/dark_mode.dart';
import '/global/variables.dart';
import '/services/lang_service.dart';

class Tutorial {
  const Tutorial(this.context, {this.alwaysShow = false});
  final BuildContext context;
  final bool alwaysShow;

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
    if (!alwaysShow) {
      if (!Global.appSettings.isFreshUser) return <TargetFocus>[];
    }
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
            child: Text(arb.selectTheCountryYouWantToTransferTo, style: _style),
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
            child: Text(
              arb.selectTheReceivingCity,
              style: _style,
              textAlign: TextAlign.end,
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
            child: Text(
              arb.knowTheCurrentExchangeRateAndChooseYourPreferredAgent,
              style: _style,
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
        contents: [
          TargetContent(
            child: Text(
              arb.enterTheAmountYouWantToTransferInTheUSDTWhichIsEqualToTheValueOfTheUSDollar,
              style: _style,
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
            child: Text(
              arb.theAmountRequiredToBeTransferredInYourLocalCurrencyIsApproximatelyBasedOnTheCurrentExchangeRate,
              style: _style,
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
        contents: [
          TargetContent(
            child: Text(
              arb.theAmountTheRecipientWillReceiveDependsOnTheExchangeRateOfTheSelectedAgent,
              style: _style,
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
        contents: [
          TargetContent(
            child: Text(
              arb.afterCompletingTheTransferInformationClickHereToSpecifyTheNameOfTheRecipientAndPayTheAmount,
              style: _style,
            ),
          ),
        ],
      ),
    );
    return targets;
  }

  void showTutorial(List<TargetFocus> targets) {
    if (!alwaysShow) {
      if (!Global.appSettings.isFreshUser) return;
    }
    arb = AppLocalizations.of(context)!;
    TutorialCoachMark(
      targets: targets,
      paddingFocus: 10,
      textSkip: arb.skip,
      textStyleSkip: _style,
      opacityShadow: context.isDarkMode ? 0.6 : 0.5,
      pulseEnable: false,
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
