import 'package:flutter/material.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key,  required this.padding,}) : super(key: key);
 final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 3.7),
      child: Container(
        padding: padding,
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            color:Theme.of(context).buttonTheme.colorScheme?.primary,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
