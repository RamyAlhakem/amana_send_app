import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/widgets/buttons/expand_button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_c.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/user_avatar.dart';
import '/configs/configs.dart';
import '/helper/helper.dart';

class SupportBody extends StatelessWidget {
  const SupportBody({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations arb = AppLocalizations.of(context)!;
    const double logoPad = kToolbarHeight + 40;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
      child: Column(
        children: [
          Container(
            decoration: Decorations.main(context),
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            padding: const EdgeInsets.fromLTRB(11, 12, 11, 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const UserAvatar(
                      icon: Icon(
                        LineIcons.headset,
                        color: MainColors.color1,
                        size: 40,
                      ),
                      maxRadius: 80,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextX(
                            arb.amanaSendSupportTeam,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const HDivider(height: 10),
                          TextX(
                            arb.dearValuedCustomerAmanaSendSupportTeamIsHereToHelpYouPleaseFeelFreeToContactUsViaTheFollowing,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextX(arb.contactDetails),
                const SizedBox(height: 10),
                Row(children: [
                  _social(
                    const Color(0xff293884),
                    'assets/svg/web.svg',
                    arb.website,
                    iColor: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  _social(
                    const Color(0xff039be5),
                    'assets/svg/telegram.svg',
                    arb.telegram,
                  ),
                ]),
                const HDivider(height: 20),
                TextX(
                  arb.workingHours,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 12),
                RowSpaceBetween([
                  TextX(
                    arb.mondayToSaturday,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextX(
                    '09:00 - 17:00',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]),
                const SizedBox(height: 6),
                RowSpaceBetween([
                  TextX(
                    arb.sunday,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextX(
                    arb.closed,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(logoPad, 10, logoPad, 20),
            child: Image.asset(
              'assets/images/icon${context.isDarkMode ? '_light' : ''}.png',
              height: 120,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                // Center(child: GeneralWidgets.privacyPolicy(context)),
                TextC(
                  'Version ${Configs.version}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                // const SizedBox(height: 10),
                // TextC(
                //   '${DateTime.now().year} © ${'All rights reserved AmanaSend'}',
                //   style: Theme.of(context).textTheme.bodySmall,
                //   textAlign: TextAlign.center,
                // ),
                // TextC(
                //   'Companies house number 1234230',
                //   style: Theme.of(context).textTheme.bodySmall,
                //   textAlign: TextAlign.center,
                // ),
                // TextC(
                //   'HMRC AML Registration Number XVML00000151047',
                //   style: Theme.of(context).textTheme.bodySmall,
                //   textAlign: TextAlign.center,
                // ),
                // TextC(
                //   'FCA Number 939430',
                //   style: Theme.of(context).textTheme.bodySmall,
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _social(
    Color color,
    String svg,
    String title, {
    Color? iColor,
    TextDirection? textDirection,
  }) {
    return ExpandButton(
      () {
        switch (svg) {
          case 'assets/svg/web.svg':
            Helper.launchURL(Configs.baseUrl);
            break;
          // case 'assets/svg/phone.svg':
          //   Helper.launchURL('tel:00442088111222');
          //   break;
          // case 'assets/svg/facebook.svg':
          //   Helper.launchURL('https://www.facebook.com/profile.php?id=00045/');
          //   break;
          // case 'assets/svg/instagram.svg':
          //   Helper.launchURL('https://www.instagram.com/');
          //   break;
          case 'assets/svg/telegram.svg':
            Helper.launchURL('https://t.me/AMANA_SEND');
            break;
          // case 'assets/svg/location.svg':
          //   Helper.launchURL('https://goo.gl/maps/dRf6y5PdR89');
          //   break;
        }
      },
      height: 45,
      color: color,
      borderRadius: 8,
      Row(
        children: [
          SvgPicture.asset(svg, height: 20, color: iColor),
          const SizedBox(width: 10),
          Flexible(
            child: FittedBox(
              child: TextX(
                title.toUpperCase(),
                style: const TextStyle(color: Colors.white),
                textDirection: textDirection,
              ),
            ),
          )
        ],
      ),
    );
  }
}
