import 'dart:math';

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({required this.child, super.key, required this.size});

  final Widget child;
  final Size size;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  late final Animation<Offset> _pageTransitionAnimation;
  late final Animation<Offset> _pageContentAnimation;

  late List<Offset> _points;
  late AnimationController _contentController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _pageContentAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.linear,
      ),
    );

    _pageTransitionAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: const Offset(0.0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _waveController,
        curve: Curves.linear,
      ),
    ) //This listener will trigger the AnimatedCrossFade to rebuild showing the perfume result
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {});
          _contentController.forward();
        }
      });

    _initPoints();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _initPoints() {
    _points = [];
    var r = Random();
    for (var i = 0; i < widget.size.width; i++) {
      var x = i.toDouble();
      var y = r.nextDouble() * (widget.size.height);

      _points.add(Offset(x, y));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget result;
        if (_pageTransitionAnimation.isCompleted) {
          result = SlideTransition(
            position: _pageContentAnimation,
            child: Container(
              color: Colors.transparent,
              child: widget.child,
            ),
          );
        } else {
          result = SlideTransition(
            position: _pageTransitionAnimation,
            child: ClipPath(
              clipper: WaveClipper(_waveController.value, _points),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.purple.shade900,
                      Colors.purple.shade900,
                      Colors.transparent,
                    ],
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.75, 1.0],
                  ),
                ),
              ),
            ),
          );
        }

        return result;
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  WaveClipper(this.value, this.wavePoints);

  double value;
  List<Offset> wavePoints;

  @override
  Path getClip(Size size) {
    var path = Path();
    _makeCurve(size);
    path.addPolygon(wavePoints, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

  void _makeCurve(Size size) {
    final amplitude = size.height / 15;
    final yOffset = amplitude;

    for (var x = 0; x < size.width; x++) {
      var y = (amplitude) * sin(x / 100 - value) + yOffset;

      var newPoint = Offset(x.toDouble(), y);
      wavePoints[x] = newPoint;
    }
  }
}
