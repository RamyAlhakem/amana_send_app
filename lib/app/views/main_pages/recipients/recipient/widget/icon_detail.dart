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
    return Row(
      children: [
        UserAvatar(code: recipient.country.coCode),
        const SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextX(
                Helper.getRecipientName(recipient),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(children: [
                if (!isTransfer)
                  TextX(
                    '${recipient.country.currency.code} - ',
                    style: const TextStyle(fontSize: 8),
                  ),
                TextX(
                  isTransfer ? date : recipient.country.enName,
                  style: TextStyle(
                    fontSize: isTransfer ? 10 : 8,
                    color: isTransfer ? Colors.grey : null,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
