import 'package:flutter/material.dart';

class Expander extends StatefulWidget {
  const Expander({super.key, required this.expand, required this.child});

  final bool expand;
  final Widget child;

  @override
  State<Expander> createState() => _ExpanderState();
}

class _ExpanderState extends State<Expander> with TickerProviderStateMixin {
  late AnimationController expander;
  late Animation<double> animate;
  final Duration duration = const Duration(milliseconds: 300);
  final Duration initDuration = const Duration(milliseconds: 50);
  void expand(bool _) {
    if (mounted) _ ? expander.forward() : expander.reverse();
  }

  @override
  void initState() {
    super.initState();
    expander = AnimationController(duration: duration, vsync: this);
    animate = CurvedAnimation(parent: expander, curve: Curves.fastOutSlowIn);
    Future.delayed(initDuration, () => expand(widget.expand));
  }

  @override
  void didUpdateWidget(covariant Expander oldWidget) {
    super.didUpdateWidget(oldWidget);
    expand(widget.expand);
  }

  @override
  void dispose() {
    expander.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animate,
      axis: Axis.vertical,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(expander),
        child: widget.child,
      ),
    );
  }
}
