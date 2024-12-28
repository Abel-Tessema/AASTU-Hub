import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class LoadingAnimatedButton extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Function() onTap;
  final double width;
  final double height;

  final Color color;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  const LoadingAnimatedButton(
      {super.key,
      required this.child,
      required this.onTap,
      this.width = 200,
      this.height = 50,
      this.color = Colors.indigo,
      this.borderColor = Colors.white,
      this.borderRadius = 15.0,
      this.borderWidth = 3.0,
      this.duration = const Duration(milliseconds: 1500)});

  @override
  State<LoadingAnimatedButton> createState() => _LoadingAnimatedButtonState();
}

class _LoadingAnimatedButtonState extends State<LoadingAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(
        widget.borderRadius,
      ),
      splashColor: widget.color,
      child: CustomPaint(
        painter: LoadingPainter(
            animation: _animationController,
            borderColor: widget.borderColor,
            borderRadius: widget.borderRadius,
            borderWidth: widget.borderWidth,
            color: widget.color),
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(5.5),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  final Animation animation;
  final Color color;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  LoadingPainter(
      {required this.animation,
      this.color = Colors.orange,
      this.borderColor = Colors.white,
      this.borderRadius = 15.0,
      this.borderWidth = 3.0})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
              colors: [
                color.withOpacity(.25),
                color,
              ],
              startAngle: 0.0,
              endAngle: vector.radians(180),
              stops: const [.75, 1.0],
              transform:
                  GradientRotation(vector.radians(360.0 * animation.value)))
          .createShader(rect);

    final path = Path.combine(
      PathOperation.xor,
      Path()
        ..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(borderRadius))),
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            rect.deflate(3.5),
            Radius.circular(borderRadius),
          ),
        ),
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            rect.deflate(1.5), Radius.circular(borderRadius)),
        Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// var n = {
//   "user": {
//     "id": 185299,
//     "first_name": 251911299848,
//     "last_name": 251911299848,
//     "email": null,
//     "phone_number": 251911299848,
//     "profile_picture": null,
//     "subscriber": {
//       "id": 149182,
//       "isFromSMS": false,
//       "status": "inactive",
//       "due_date": 6,
//       "subscription_id": 18
//     },
//     "created_at": "2024-08-06T09:53:04.000Z",
//     "updated_at": "2024-08-06T09:53:04.000Z"
//   },
//   "iat": 1734874556,
//   "exp": 1737466556
// };
