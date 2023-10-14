import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  const Wave({required this.child, super.key, required this.size});

  final Widget child;
  final Size size;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  late List<Offset> _points;
  late AnimationController _animationController;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: const Offset(0.0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addListener(() {
        setState(() {});
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
    for (var i = 0; i < widget.size.width; i++) {
      var x = i.toDouble();
      var y = r.nextDouble() * (widget.size.height);

      _points.add(Offset(x, y));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: _offsetAnimation.isCompleted
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 100),
      firstChild: SlideTransition(
        position: _offsetAnimation,
        child: ClipPath(
          clipper: WaveClipper(_animationController.value, _points),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  AppTheme.violetPastel,
                  AppTheme.violetPastel,
                  Colors.transparent,
                ],
                end: Alignment.bottomCenter,
                stops: [0.0, 0.65, 1.0],
              ),
            ),
          ),
        ),
      ),
      secondChild: Container(
        color: Colors.transparent,
        child: widget.child,
      ),
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
