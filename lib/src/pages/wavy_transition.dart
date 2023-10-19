import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({required this.child, super.key, required this.size});

  final Widget child;
  final Size size;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  late List<double> _points;
  late AnimationController _animationController;
  late AnimationController _slideController;
  late final Animation<double> _curveAnimation;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.linear,
      ),
    );

    _curveAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )
      ..addListener(() {
        _initPoints();
      }) //This listener will trigger the AnimatedCrossFade to rebuild showing the second Child
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _slideController.forward();
          setState(() {});
        }
      });

    _initPoints();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initPoints() {
    _points = [];
    var r = Random();
    for (var i = 0; i <= widget.size.height / 100; i++) {
      var y = r.nextDouble();

      _points.add(y + _curveAnimation.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedCrossFade(
      crossFadeState: _curveAnimation.isCompleted
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 100),
      firstChild: Center(
        child: CustomPaint(
          size: Size(size.width, size.height),
          painter: PathPainter(
            value: _animationController.value,
            wavePoints: _points,
          ),
        ),
      ),
      secondChild: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  PathPainter({
    required this.value,
    required this.wavePoints,
  });

  double value;
  List<double> wavePoints;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    // paint the gradient fill
    var fillPath = _makeCurve(size);
    paint.style = PaintingStyle.fill;
    paint.shader = ui.Gradient.linear(
      Offset.zero,
      Offset(0.0, size.height),
      [
        Colors.purple,
        Colors.transparent,
      ],
    );

    canvas.drawPath(fillPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  Path _makeCurve(Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    final segmentWidth = width / (wavePoints.length * 3); // curved line

    for (var i = 1; i < wavePoints.length; i++) {
      path.cubicTo(
        (3 * i + 1) * segmentWidth,
        height - wavePoints[i - 1] * height,
        (3 * i + 2) * segmentWidth,
        height - wavePoints[i] * height,
        (3 * i + 3) * segmentWidth,
        height - wavePoints[i] * height,
      );
    }
    path.lineTo(width, height - wavePoints[wavePoints.length - 1] * height);
    // for the gradient fill, we want to close the path

    path.lineTo(width, height);
    path.lineTo(0, height);

    return path;
  }
}
