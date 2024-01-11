import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/views/registration/provider/registration_state.dart';

class LogInFooter extends StatelessWidget {
  const LogInFooter({
    super.key,
    required this.isRegister,
    required this.title,
    required this.subTitle,
  });

  final bool isRegister;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<RegistrationState>().register(isRegister),
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(text: title),
              const TextSpan(text: '  '),
              TextSpan(
                text: subTitle,
                style: const TextStyle(color: MainColors.color2),
              ),
            ],
          ),
          maxLines: 1,
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
