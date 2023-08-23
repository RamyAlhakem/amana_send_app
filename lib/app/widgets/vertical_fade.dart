import 'dart:async';
import 'package:flutter/material.dart';

class VerticalFade extends StatefulWidget {
  const VerticalFade({super.key, required this.child, this.delay});

  final Widget child;
  final int? delay;

  @override
  State<VerticalFade> createState() => _VerticalFadeState();
}

class _VerticalFadeState extends State<VerticalFade>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: _animController,
    );

    _animOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.35),
      end: Offset.zero,
    ).animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay ?? 600), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
