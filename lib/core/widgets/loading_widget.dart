import 'package:flutter/material.dart';
import 'dart:math';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CustomPaint(
              painter: RotatingArcPainter(_controller),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Loading...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class RotatingArcPainter extends CustomPainter {
  final Animation<double> animation;
  RotatingArcPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = 2 * pi * animation.value;
    final sweep = 2 * pi / 3; // 120 degrees (1/3 circle)

    paint.color = Colors.green;
    canvas.drawArc(rect, startAngle, sweep, false, paint);

    paint.color = Colors.yellow;
    canvas.drawArc(rect, startAngle + sweep, sweep, false, paint);

    paint.color = Colors.red;
    canvas.drawArc(rect, startAngle + 2 * sweep, sweep, false, paint);
  }

  @override
  bool shouldRepaint(covariant RotatingArcPainter oldDelegate) => true;
}

class ErrorWidgetWithRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorWidgetWithRetry({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(message),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            )
          ],
        ),
      ),
    );
  }
}
