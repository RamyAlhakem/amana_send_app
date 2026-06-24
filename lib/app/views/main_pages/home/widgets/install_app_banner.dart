import 'package:amana_send/app/views/main_pages/provider/calculator.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class InstallAppBanner extends StatelessWidget {
  final AppLocalizations arb;
  final Calculator state;

  const InstallAppBanner({
    super.key,
    required this.arb,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => state.changeInstall(false),
            icon: const Icon(Icons.close),
          ),
          Text(
            arb.installAppOnYourPhoneForACompleteExperience,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () => _showInstallDialog(context),
            child: Text(arb.installNow),
          ),
        ],
      ),
    );
  }

  void _showInstallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  arb.amanaSendCanBeInstalledAsAnAppOnYourDevice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  arb.followTheInstructionsAboveToUseTheSiteAsAnAppWithoutOpeningItFromTheBrowser,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(arb.ok),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
