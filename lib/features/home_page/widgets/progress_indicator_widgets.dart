import 'dart:math';
import 'package:clock_app/main.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> backgroundGradientColors;
  final List<double>? stops;
  final double size;

  const ProgressIndicatorWidget({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.backgroundGradientColors,
    required this.stops,
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Liquid Progress Indicator
          RepaintBoundary(
            child: TweenAnimationBuilder<double>(
              duration: animationDuration,
              curve: animationCurve,
              tween: Tween<double>(
                  begin: darkMode ? 0.7 : 0.001, end: darkMode ? 0.001 : 0.7),
              builder: (context, animatedAlpha, child) {
                return CustomPaint(
                  size: Size(size, size),
                  painter: LiquidPainter(
                    value: value,
                    maxValue: maxValue,
                    backgroundGradientColors: backgroundGradientColors
                        .map((e) => e.withValues(alpha: animatedAlpha))
                        .toList(),
                    stops: stops,
                  ),
                );
              },
            ),
          ),

          // SizedBox(height: 50),
          // Circular Progress Bar
          RepaintBoundary(
            child: TweenAnimationBuilder<double>(
                duration: animationDuration,
                curve: animationCurve,
                tween: Tween<double>(
                    begin: darkMode ? 0.6 : 0.2, end: darkMode ? 0.2 : 0.6),
                builder: (context, animatedAlpha, child) {
                  return TweenAnimationBuilder<double>(
                      duration: animationDuration,
                      curve: animationCurve,
                      tween: Tween<double>(
                          begin: darkMode ? 3 : 8, end: darkMode ? 8 : 3),
                      builder: (context, animatedStrokeWidth, child) {
                        return CustomPaint(
                          size: Size(size, size),
                          painter: RadialProgressPainter(
                            value: value,
                            stops: stops,
                            backgroundGradientColors: backgroundGradientColors,
                            minValue: minValue,
                            maxValue: maxValue,
                            strokeWidth: animatedStrokeWidth,
                            bgColor:
                                Colors.white.withValues(alpha: animatedAlpha),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}

class LiquidPainter extends CustomPainter {
  final double value;
  final double maxValue;
  final List<double>? stops;
  final List<Color> backgroundGradientColors;

  /// Creates a [LiquidPainter] with the given [value] and [maxValue].
  LiquidPainter({
    required this.value,
    required this.stops,
    required this.maxValue,
    required this.backgroundGradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double diameter = min(size.height, size.width);
    double radius = diameter / 2;

    // Defining coordinate points. The wave starts from the bottom and ends at the top as the value changes.
    double pointX = 0;
    double pointY = diameter -
        ((diameter + 10) *
            (value /
                maxValue)); // 10 is an extra offset added to fill the circle completely

    Path path = Path();
    path.moveTo(pointX, pointY);

    // Amplitude: the height of the sine wave
    double amplitude = 10;

    // Period: the time taken to complete one full cycle of the sine wave.
    // f = 1/p, the more the value of the period, the higher the frequency.
    double period = value / maxValue;

    // Phase Shift: the horizontal shift of the sine wave along the x-axis.
    double phaseShift = value * pi;

    // Plotting the sine wave by connecting various paths till it reaches the diameter.
    // Using this formula: y = A * sin(ωt + φ) + C
    for (double i = 0; i <= diameter; i++) {
      path.lineTo(
        i + pointX,
        pointY + amplitude * sin((i * 2 * period * pi / diameter) + phaseShift),
      );
    }

    // Plotting a vertical line which connects the right end of the sine wave.
    path.lineTo(pointX + diameter, diameter);
    // Plotting a vertical line which connects the left end of the sine wave.
    path.lineTo(pointX, diameter);
    // Closing the path.
    path.close();

    Paint paint = Paint()
      ..shader = SweepGradient(
        colors: backgroundGradientColors
        // .map((e) => e.withValues(alpha: darkMode ? 0.1 : 0.7))
        // .toList()
        ,
        startAngle: pi / 2,
        endAngle: 5 * pi / 2,
        tileMode: TileMode.clamp,
        stops: stops,
      ).createShader(
          Rect.fromCircle(center: Offset(diameter, diameter), radius: radius))
      ..style = PaintingStyle.fill;

    // Clipping rectangular-shaped path to Oval.
    Path circleClip = Path()
      ..addOval(Rect.fromCenter(
          center: Offset(radius, radius), width: diameter, height: diameter));
    canvas.clipPath(circleClip, doAntiAlias: true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RadialProgressPainter extends CustomPainter {
  final double value;
  final List<Color> backgroundGradientColors;
  final double minValue;
  final List<double>? stops;
  final double maxValue;
  double strokeWidth;
  final Color bgColor;

  RadialProgressPainter({
    required this.value,
    required this.stops,
    required this.backgroundGradientColors,
    required this.minValue,
    required this.maxValue,
    this.strokeWidth = 2,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double diameter = min(size.height, size.width);
    final double radius = diameter / 2;
    final double centerX = radius;
    final double centerY = radius;

    // const double strokeWidth = 2;

    final Paint progressPaint = Paint()
      ..shader = SweepGradient(
        colors: backgroundGradientColors,
        startAngle: -pi / 2,
        endAngle: 3 * pi / 2,
        tileMode: TileMode.repeated,
      ).createShader(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressTrackPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    double sweepAngle = 2 * pi * value / maxValue;

    // Drawing track (background circle)
    canvas.drawCircle(Offset(centerX, centerY), radius, progressTrackPaint);

    // Drawing progress arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever the progress value changes
  }
}
