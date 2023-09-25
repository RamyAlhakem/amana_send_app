import 'package:flutter/material.dart';

class ScrollLooper extends StatefulWidget {
  const ScrollLooper({
    required this.child,
    Key? key,
    this.delay = const Duration(seconds: 1),
    this.duration = const Duration(seconds: 4),
    this.gap = 1,
    this.delayAfterScrollInput = const Duration(seconds: 1),
  }) : super(key: key);

  /// Widget to display in loop
  ///
  /// required
  final Widget child;

  /// Duration to wait before starting animation
  ///
  /// Default set to Duration(seconds: 1).
  ///

  final Duration delay;

  /// Duration of animation
  ///
  /// Default set to Duration(seconds: 30).
  final Duration duration;

  /// Sized between end of child and beginning of next child instance
  ///
  /// Default set to 25.
  final double gap;

  /// Duration to wait before starting animation, after user scroll Input.
  ///
  /// Default set to Duration(seconds: 1).
  ///
  final Duration delayAfterScrollInput;

  @override
  State<ScrollLooper> createState() => _ScrollLooperState();
}

class _ScrollLooperState extends State<ScrollLooper>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationCtrl;
  late Animation<Offset> offset;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      await Future.delayed(widget.delayAfterScrollInput);
      if (mounted) animationHandler();
    });

    animationCtrl = AnimationController(duration: widget.duration, vsync: this);

    offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-.5, 0),
    ).animate(animationCtrl);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(widget.delay);
      if (mounted) animationHandler();
    });
    super.initState();
  }

  void animationHandler() {
    if (scrollController.position.maxScrollExtent > 0) {
      if (mounted) animationCtrl.forward().then((_) => animationCtrl.reverse());
    } else {
      if (mounted) animationCtrl.reverse().then((_) => animationCtrl.forward());
    }
  }

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: SlideTransition(
        position: offset,
        child: widget.child,
      ),
    );
  }
}
