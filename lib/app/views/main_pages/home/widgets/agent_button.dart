import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/main_pages/provider/calculator.dart';
import '/app/widgets/buttons/button.dart';
import '/app/widgets/image/image_widget.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/models/agent.dart';
import '/services/lang_service.dart';

class AgentButton extends StatelessWidget {
  const AgentButton(
    this.onPressed, {
    required this.selected,
    required this.agent,
    this.height = 50,
    this.width,
    super.key,
  });

  final bool selected;
  final AgentModel agent;
  final void Function()? onPressed;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final Calculator state = context.watch<Calculator>();
    final bool isAR = LangService.isAR();
    final double rate = agent.rate * (1 - (state.percentFee / 100));
    final bool usd = agent.usdAvailability == 2;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Button(
          onPressed,
          height: height,
          padding: EdgeInsets.zero,
          color: Theme.of(context).cardColor,
          borderColor: selected ? MainColors.color2 : Colors.transparent,
          borderWidth: 2,
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                ImageWidget(
                  agent.iconUrl,
                  height: 30,
                  width: 60,
                  radius: 6,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextX(
                          agent.name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: FittedBox(
                          child: Text.rich(
                            textScaleFactor: 1.0,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${isAR ? 'USDT 1' : '1 USDT'} = ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 11),
                                ),
                                TextSpan(
                                  text: Helper.priced(rate,
                                      currencyCode: usd
                                          ? 'USD'
                                          : state
                                              .receiverCountry.currency.code),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selected)
          Positioned(
            top: -8,
            right: isAR ? null : -4,
            left: isAR ? -4 : null,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: MainColors.color2, width: 2),
              ),
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ),
          ),
      ],
    );
  }
}
