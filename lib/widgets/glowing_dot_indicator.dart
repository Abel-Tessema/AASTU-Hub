import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class GlowingDotIndicator extends StatelessWidget {
  final Color glowColor;
  final Color color;
  final double size;

  const GlowingDotIndicator(
      {super.key,
      required this.glowColor,
      required this.size,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WidgetAnimator(
          atRestEffect: WidgetRestingEffects.size(effectStrength: 0.5),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.3)),
          ),
        ),
        Container(
          width: size - 10,
          height: size - 10,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.greenAccent),
        ),
      ],
    );
  }
}
