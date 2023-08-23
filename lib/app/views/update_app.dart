import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/configs/configs.dart';
import '/helper/helper.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  late AppLocalizations? arb;

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AutoAppBar(leading: SizedBox()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, kToolbarHeight * 2, 0, 10),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
                height: 100,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                padding: const EdgeInsets.all(20),
                decoration: Decorations.main(context),
                child: Column(
                  children: [
                    TextX(
                      arb!.updateRequired,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    TextX(
                      arb!.newVersionIsAvailable,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const HDivider(height: 40),
                    TextX(
                      arb!.thereIsANewVersionAvailableToDownloadPleaseUpdateAmanaSendToContinue,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 25),
                    Button(
                      () => Helper.launchURL(Configs.storeUrl),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextX(
                            arb!.updateAmanaSend,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.sync)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
