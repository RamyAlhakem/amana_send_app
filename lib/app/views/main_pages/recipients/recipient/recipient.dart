import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/recipients/provider/recipients_state.dart';
import '/app/widgets/auto_app_bar.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/dialogs/submit.dart';
import '/app/widgets/row.dart';
import '/app/widgets/text/text_x.dart';
import '/app/widgets/user_avatar.dart';
import '/graphql/api/delete_recipient.dart';
import '/helper/helper.dart';
import '/models/metadata.dart';
import '/models/recipient.dart';

class Recipient extends StatefulWidget {
  const Recipient(this.recipient, {super.key});

  final String recipient;

  @override
  State<Recipient> createState() => _RecipientState();
}

class _RecipientState extends State<Recipient> {
  late AppLocalizations? arb;
  late RecipientModel recipient;
  late RecipientsState pr;

  @override
  void initState() {
    super.initState();
    recipient = RecipientModel.fromJson(jsonDecode(widget.recipient));
    pr = Provider.of<RecipientsState>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutoAppBar(
        title: '${recipient.firstName} ${recipient.lastName}',
      ),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: Decorations.main(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(code: recipient.country.coCode),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextX(
                          Helper.getRecipientName(recipient),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextX(
                          recipient.dateAdded,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RowSpaceBetween([
                TextX(arb!.mobileNumber),
                TextX('${recipient.mobile}'),
              ]),
              const SizedBox(height: 8),
              // RowSpaceBetween([

              //   TextX(arb!.countryCity),
              //   if (recipient.country.cities.isNotEmpty)
              //     TextX(
              //         '${recipient.country.enName}/${recipient.country.cities.first.name}'),
              // ]),
              // const SizedBox(height: 8),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Button(
            () => pr.editRecipient(context, recipient),
            color: Colors.transparent,
            height: 50,
            width: MediaQuery.of(context).size.width,
            borderRadius: 4,
            borderColor: MainColors.color2,
            TextX(
              arb!.editRecipient,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MainColors.color2,
                  ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Button(
            () => SubmitDialog(
              () => DeleteRecipient(context, id: recipient.id).request(),
              content:
                  '${arb!.areYouSureYouWantToDelete} ${recipient.firstName}',
            ).show(),
            height: 50,
            color: Colors.transparent,
            borderColor: MainColors.red,
            borderRadius: 4,
            TextX(
              arb!.deleteRecipient,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MainColors.red,
                  ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: SizedBox(
        height:
            !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS ? 70 : 60,
        child: Button(
          () {
            if (AppMetadata.get.maintenanceMode) {
              return Helper.bannerWarning(
                '\n${AppMetadata.get.maintenanceMessage}\n',
              );
            }
            final calculator = Provider.of<Calculator>(context, listen: false);
            calculator.setReceiverCountry(recipient.country);
            calculator.agentsVisibility(true);
            calculator.recipientSend(recipient, navigate: true);
          },
          borderRadius: 0,
          TextX(
            arb!.sendMoney,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
