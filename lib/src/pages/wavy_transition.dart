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
  late final Animation<double> _curveAnimation;
  late final Animation<Offset> _offsetAnimation;

  late AnimationController _curveController;
  late List<double> _points;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _curveController = AnimationController(
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
        parent: _curveController,
        curve: Curves.linear,
      ),
    )
      ..addListener(() {
        _initPoints();
      })
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
    _curveController.dispose();
    super.dispose();
  }

  void _initPoints() {
    _points = [];
    var r = Random();
    for (var i = 0; i <= widget.size.height / 100; i++) {
      var y = r.nextDouble();

      _points.add(y + _curveAnimation.value);
    }
    
    print(_points);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget result;
        if (_curveAnimation.isCompleted) {
          result = SlideTransition(
            position: _offsetAnimation,
            child: Container(
              color: Colors.white,
              child: widget.child,
            ),
          );
        } else {
          result = Center(
            child: CustomPaint(
              size: Size(size.width, size.height),
              painter: PathPainter(
                wavePoints: _points,
              ),
            ),
          );
        }

        return result;
      },
    );
  }
}

class PathPainter extends CustomPainter {
  PathPainter({
    required this.wavePoints,
  });

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
        Colors.purple.shade900,
        Colors.white,
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
