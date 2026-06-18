import 'package:amana_send/services/lang_service.dart';
import 'package:flutter/material.dart';

import '/app/widgets/text/text_x.dart';
import '/app/widgets/user_avatar.dart';
import '/helper/helper.dart';
import '/models/recipient.dart';

class RecipientIconDetail extends StatelessWidget {
  const RecipientIconDetail({
    super.key,
    required this.recipient,
    this.isTransfer = false,
    this.date = '',
  });

  final RecipientModel recipient;
  final String date;
  final bool isTransfer;

  @override
  Widget build(BuildContext context) {
    final isAr = LangService.isAR();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(code: recipient.country.coCode),
        const SizedBox(width: 10),
        Flexible(
          fit: FlexFit.loose,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: LangService.isAR()
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: TextX(
                        Helper.getRecipientName(recipient),
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ),
                  ),
                  Row(children: [
                    if (!isTransfer)
                      Flexible(
                        child: TextX(
                          '${recipient.country.currency.code} - ',
                          style: const TextStyle(fontSize: 8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Expanded(
                      child: TextX(
                        isTransfer ? date : recipient.country.enName,
                        style: TextStyle(
                          fontSize: isTransfer ? 10 : 8,
                          color: isTransfer ? Colors.grey : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ]),
                  isAr
                      ? Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                              " ${recipient.mobile} ${recipient.country.phoneCode}+",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis))
                      : Text(
                          "+${recipient.country.phoneCode} ${recipient.mobile}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
