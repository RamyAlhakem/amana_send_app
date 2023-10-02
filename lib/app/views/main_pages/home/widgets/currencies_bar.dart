import 'dart:async';

import 'package:flutter/material.dart';

import '/app/theme/decoration/decorations.dart';
import '/app/widgets/divider.dart';
import '/app/widgets/text/text_x.dart';
import '/helper/helper.dart';
import '/models/currency.dart';

class CurrenciesNews extends StatefulWidget {
  const CurrenciesNews({Key? key, required this.currencies}) : super(key: key);
  final List<CurrencyModel> currencies;

  @override
  State<CurrenciesNews> createState() => _CurrenciesNewsState();
}

class _CurrenciesNewsState extends State<CurrenciesNews> {
  final ScrollController controller = ScrollController();
  late Timer timer;
  final double scrollSpeed = 2.0; // Adjust scroll speed.
  double scrollOffset = 0;

  void _startAutoScroll() {
    // Start the timer to auto-scroll the ListView
    timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (controller.hasClients) {
        scrollOffset += scrollSpeed;
        controller.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) => timer.cancel(),
      onPointerMove: (event) => scrollOffset = controller.offset,
      onPointerUp: (event) {
        controller.position.isScrollingNotifier.addListener(() {
          if (!controller.position.isScrollingNotifier.value) {
            timer.cancel();
            _startAutoScroll();
          }
        });
      },
      child: Container(
        height: 35, // Adjust the height as needed
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        decoration: Decorations.note(context),
        child: ListView.builder(
          controller: controller,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          itemBuilder: (_, i) {
            final int x = i % widget.currencies.length;
            return Row(children: [
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextX(
                    widget.currencies[x].name,
                    style: const TextStyle(fontSize: 9),
                  ),
                  Text.rich(
                    textScaleFactor: 1.0,
                    TextSpan(
                      children: <TextSpan>[
                        const TextSpan(text: '1 USDT = '),
                        TextSpan(
                          text: Helper.priced(
                            widget.currencies[x].rate,
                            currencyCode: widget.currencies[x].code,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              // if (x + 1 < widget.currencies.length) const VDivider(margin: 4),
              const VDivider(margin: 4),
            ]);
          },
        ),
      ),
    );
  }
}
