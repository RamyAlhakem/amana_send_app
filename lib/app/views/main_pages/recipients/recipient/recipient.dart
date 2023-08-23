import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '/app/extensions/text_underline.dart';
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
  late AppLocalizations? _arb;
  late RecipientModel _recipient;
  late RecipientsState _pr;

  @override
  void initState() {
    super.initState();
    _recipient = RecipientModel.fromJson(jsonDecode(widget.recipient));
    _pr = Provider.of<RecipientsState>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    _arb = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AutoAppBar(
        title: '${_recipient.arFirstName} ${_recipient.arLastName}',
        actions: [
          Button(
            () => _pr.editRecipient(context, _recipient),
            color: Colors.transparent,
            borderRadius: 0,
            TextX(
              _arb!.editRecipient,
              style: Theme.of(context).textTheme.bodySmall?.underlineDashed(
                    color: MainColors.color1,
                  ),
            ),
          ),
        ],
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
                  UserAvatar(code: _recipient.country.coCode),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextX(
                          Helper.getRecipientName(_recipient),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextX(
                          _recipient.dateAdded,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              RowSpaceBetween([
                TextX(_arb!.relativeRelation),
                TextX(_recipient.relative),
              ]),
              const SizedBox(height: 8),
              RowSpaceBetween([
                TextX(_arb!.mobileNumber),
                TextX('${_recipient.mobile}'),
              ]),
              const SizedBox(height: 8),
              RowSpaceBetween([
                TextX(_arb!.countryCity),
                if (_recipient.country.cities.isNotEmpty)
                  TextX(
                      '${_recipient.country.enName}/${_recipient.country.cities.first.name}'),
              ]),
              const SizedBox(height: 8),
              RowSpaceBetween([
                TextX(_arb!.area),
                TextX(_recipient.area),
              ]),
              const SizedBox(height: 8),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Button(
            () => SubmitDialog(
              () => DeleteRecipient(context, id: _recipient.id).request(),
              content:
                  '${_arb!.areYouSureYouWantToDelete} ${_recipient.arFirstName}',
            ).show(context),
            height: 50,
            color: Colors.transparent,
            borderColor: MainColors.red,
            borderRadius: 4,
            TextX(
              _arb!.deleteRecipient,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MainColors.red,
                  ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: SizedBox(
        height: Platform.isIOS ? 70 : 60,
        child: Button(
          () {
            if (AppMetadata.get.maintenanceMode) {
              return Helper.bannerWarning(
                '\n${AppMetadata.get.maintenanceMessage}\n',
              );
            }
            Provider.of<Calculator>(
              context,
              listen: false,
            ).recipientSend(_recipient, navigate: true);
          },
          borderRadius: 0,
          TextX(
            _arb!.sendMoney,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
