import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/extensions/dark_mode.dart';
import '/app/theme/colors/main_colors.dart';
import '/app/widgets/text/text_x.dart';
import '/configs/configs.dart';
import '/database/injector.dart';
import '/helper/helper.dart';
import '/models/user_base.dart';
import '/services/lang_service.dart';

class AcceptTerms extends StatefulWidget {
  const AcceptTerms({super.key});

  @override
  State<AcceptTerms> createState() => _AcceptTermsState();
}

class _AcceptTermsState extends State<AcceptTerms> {
  late AppLocalizations? _arb;
  late UserBase user;

  @override
  void initState() {
    super.initState();
    user = Database().getUserBase;
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => setState(() {
        user.acceptTerms = !user.acceptTerms;
        Database().setUserBase = user;
      }),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: SizedBox(
              height: 30,
              width: 20,
              child: Checkbox(
                activeColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    width: 2.0,
                    color:
                        context.isDarkMode ? Colors.white10 : Colors.grey[350]!,
                  ),
                ),
                checkColor:
                    context.isDarkMode ? MainColors.color2 : MainColors.color1,
                value: user.acceptTerms,
                onChanged: (bool? value) => setState(() {
                  user.acceptTerms = value ?? false;
                  Database().setUserBase = user;
                }),
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextX(
            _arb!.iAccept,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => Helper.launchURL('${Configs.baseUrl}pages/terms'),
            child: TextX(_arb!.termsAndConditions, style: terms(context)),
          ),
          const SizedBox(width: 3),
          TextX(
            LangService.isAR() ? 'و' : '&',
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () =>
                Helper.launchURL('${Configs.baseUrl}pages/privacy-policy'),
            child: TextX(_arb!.privacyPolicy, style: terms(context)),
          ),
        ],
      ),
    );
  }

  TextStyle? terms(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 11, color: Colors.blue, decoration: TextDecoration.underline);
  }
}
