import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/theme/decoration/decorations.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/views/main_pages/recipients/recipient/widget/icon_detail.dart';
import '/app/widgets/row.dart';
import '/models/recipient.dart';

class RecipientSelector extends StatefulWidget {
  const RecipientSelector({
    super.key,
    required this.recipient,
    required this.select,
  });

  final RecipientModel recipient;
  final bool select;

  @override
  State<RecipientSelector> createState() => _RecipientSelectorState();
}

class _RecipientSelectorState extends State<RecipientSelector>
    with SingleTickerProviderStateMixin {
  late RecipientModel recipient;
  late Calculator _calc;

  @override
  void initState() {
    super.initState();
    recipient = widget.recipient;
    _calc = Provider.of<Calculator>(context, listen: false);
  }

  @override
  void didUpdateWidget(RecipientSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (recipient != widget.recipient) recipient = widget.recipient;
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _calc.receiverCountry.coCode == recipient.country.coCode,
      child: Container(
        decoration: Decorations.main(context),
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            RowSpaceBetween([
              RecipientIconDetail(recipient: recipient),
              Visibility(
                visible: widget.select,
                child: const Icon(
                  Icons.check_circle_outline,
                  color: MainColors.color1,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
