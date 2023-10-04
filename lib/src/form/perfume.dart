import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class PerfumeSelection extends StatefulWidget {
  const PerfumeSelection({super.key});

  @override
  State<PerfumeSelection> createState() => _PerfumeSelectionState();
}

class _PerfumeSelectionState extends State<PerfumeSelection> {
  double _size = 600.0;
  bool _large = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.purplePastel.withOpacity(0.2),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Center(
                child: AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(seconds: 1),
                  height: _size,
                  width: _size,
                  child: Image.asset('img.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: RichText(
                  key: Key(_size.toString()),
                  text: TextSpan(
                      text: 'You will enjoy ',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                            text: _large ? '100 ml' : '50 ml',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: ' of this perfume',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            )),
                      ]),
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 60,
                  width: 130,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _size = _large ? 300 : 600;
                        _large = !_large;
                      });
                    },
                    child: const Text('Toggle Size'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
