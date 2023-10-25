import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '/app/theme/decoration/decorations.dart';

class AgentDescription extends StatelessWidget {
  const AgentDescription({super.key, required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: html.isNotEmpty,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        width: MediaQuery.of(context).size.width,
        decoration: Decorations.note(context),
        child: Html(
          data: html,
          style: <String, Style>{
            'body': Style(
              fontSize: FontSize(16),
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
          },
        ),
      ),
    );
  }
}
