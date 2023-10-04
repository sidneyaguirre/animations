import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
    _colorScheme.primary.withOpacity(0.14),
    _colorScheme.surface,
  );
  late final _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    reverseDuration: const Duration(milliseconds: 1250),
    value: 0,
    vsync: this,
  );
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  bool controllerInitialized = false;
  int selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final width = MediaQuery.sizeOf(context).width;

    final status = _controller.status;

    if (width > 610) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }

    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > 610 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              CustomNavigationRail(
                backgroundColor: _backgroundColor,
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                    context.go(routeNames.elementAt(index));
                  });
                },
                railAnimation: _railAnimation,
                railFabAnimation: _railFabAnimation,
              ),
              Expanded(
                child: Container(
                  color: _backgroundColor,
                  child: widget.child,
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            barAnimation: _barAnimation,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
                context.go(routeNames.elementAt(index));
              });
            },
          ),
        );
      },
    );
  }
}
