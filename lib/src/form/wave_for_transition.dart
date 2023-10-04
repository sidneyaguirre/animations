import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wave extends StatefulWidget {
  const Wave({super.key, required this.size});

  final Size size;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late List<Offset> _points;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 2 * pi,
    );

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
      var y = r.nextDouble() * (widget.size.height * 0.8);

      _points.add(Offset(x, y));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Consumer(
            builder: (context, object, child) {
              _animationController.forward();
              _animationController.repeat();
              return child!;
            },
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(_animationController.value, _points),
                  child: MyContainer(),
                );
              },
            ),
          ),
        ],
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
    final amplitude = size.height;
    final yOffset = amplitude;

    for (var x = 0; x < size.width; x++) {
      var y = amplitude * sin(x - value) + yOffset;

      var newPoint = Offset(x.toDouble(), y);
      wavePoints[x] = newPoint;
    }
  }
}

class MyContainer extends StatelessWidget {
  const MyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      color: Colors.purple,
    );
  }
}
