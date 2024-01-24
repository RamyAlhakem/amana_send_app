import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/app/extensions/dark_mode.dart';
import '/app/widgets/text/text_x.dart';
import '/services/lang_service.dart';
import 'user_service.dart';

class Tutorial {
  const Tutorial(this.context, {this.show = false});
  final BuildContext context;
  final bool show;

  static late AppLocalizations arb;
  static GlobalKey key1 = GlobalKey(), key2 = GlobalKey(), key3 = GlobalKey();
  static GlobalKey key4 = GlobalKey(), key5 = GlobalKey(), key6 = GlobalKey();
  static GlobalKey key7 = GlobalKey();
  static const TextStyle _style = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 20.0,
  );

  static List<TargetFocus> targets() {
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

  void showTutorial() {
    if (!show && !UserService.isFresh()) return;
    arb = AppLocalizations.of(context)!;
    TutorialCoachMark(
      targets: targets(),
      paddingFocus: 10,
      textSkip: arb.skip,
      textStyleSkip: _style,
      skipWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextX(arb.skip, style: _style.copyWith(fontSize: 30)),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 40,
          )
        ],
      ),
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
