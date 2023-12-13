import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '/app/theme/colors/main_colors.dart';
import '/app/widgets/blurry_container.dart';
import '/app/widgets/buttons/button.dart';

class ScrollButton extends StatefulWidget {
  const ScrollButton({super.key, required this.scrollCtrl});
  final ScrollController scrollCtrl;

  @override
  State<ScrollButton> createState() => _ScrollButtonState();
}

class _ScrollButtonState extends State<ScrollButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollCtrl.position.maxScrollExtent > 0) {
        setState(() => _isVisible = true);
      }
    });

    widget.scrollCtrl.addListener(() {
      if (widget.scrollCtrl.position.pixels ==
          widget.scrollCtrl.position.maxScrollExtent) {
        if (_isVisible == true) {
          // only set when the previous state is true
          // Less widget rebuilds

          if (mounted) setState(() => _isVisible = false);
        }
      }

      if (widget.scrollCtrl.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          // only set when the previous state is true
          // Less widget rebuilds

          if (mounted) setState(() => _isVisible = false);
        }
      } else {
        if (widget.scrollCtrl.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            // only set when the previous state is false
            // Less widget rebuilds

            if (mounted) setState(() => _isVisible = true);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 500),
      offset: _isVisible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isVisible ? 1 : 0,
        child: BlurryContainer(
          radius: 100,
          height: 50,
          width: 50,
          sigmaX: 2,
          sigmaY: 2,
          color: Colors.transparent,
          child: Button(
            () => widget.scrollCtrl.animateTo(
              widget.scrollCtrl.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
            ),
            borderRadius: 100,
            color: MainColors.color1.withOpacity(0.2),
            borderColor: MainColors.color2.withOpacity(0.2),
            borderWidth: 6,
            padding: EdgeInsets.zero,
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 35,
              color: MainColors.color1,
            ),
          ),
        ),
      ),
    );
  }
}
