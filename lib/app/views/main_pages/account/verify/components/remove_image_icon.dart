import 'package:flutter/material.dart';

class RemoveImageIcon extends StatelessWidget {
  const RemoveImageIcon(this.onPressed, {this.topPosition = -14, super.key});

  final void Function()? onPressed;
  final double topPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPosition,
      right: -18,
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: const Icon(Icons.delete_forever, color: Colors.red),
        ),
      ),
    );
  }
}
