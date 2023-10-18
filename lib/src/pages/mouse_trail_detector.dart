import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class MouseTrailDetectorPage extends StatelessWidget {
  const MouseTrailDetectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedCursorTrail(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.purple.shade200,
                ),
                height: 200,
                padding: const EdgeInsets.all(30.0),
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: Text(
                  'Hello Flutter Conf LATAM!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IgnorePointer(
                child: Image.asset(
                  'assets/dash.png',
                  width: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
