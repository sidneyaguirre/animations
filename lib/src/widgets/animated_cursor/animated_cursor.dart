import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedCursorTrailState {
  const AnimatedCursorTrailState({
    this.offset = Offset.zero,
    this.size = defaultSize,
  });

  static const Size defaultSize = Size(20, 20);

  final Offset offset;
  final Size size;
}

class AnimatedCursorTrailProvider extends ChangeNotifier {
  AnimatedCursorTrailProvider();

  AnimatedCursorTrailState state = const AnimatedCursorTrailState();
  final listTrail = <Widget>[];

  void changeCursor(GlobalKey key, {BoxDecoration? decoration}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    state = AnimatedCursorTrailState(
      offset: renderBox.localToGlobal(Offset.zero).translate(
            renderBox.size.width / 2,
            renderBox.size.height / 2,
          ),
      size: renderBox.size,
    );

    notifyListeners();
  }

  void resetCursor() {
    state = const AnimatedCursorTrailState();
    notifyListeners();
  }

  void updateCursorPosition(Offset position) {
    state = AnimatedCursorTrailState(offset: position);
    notifyListeners();
  }
}

class AnimatedCursorTrail extends StatelessWidget {
  const AnimatedCursorTrail({
    super.key,
    this.child,
  });

  final Widget? child;

  void _onCursorUpdate(BuildContext context, PointerEvent event) =>
      context.read<AnimatedCursorTrailProvider>().updateCursorPosition(
            event.position,
          );

  List<Widget> _trail(AnimatedCursorTrailProvider provider) {
    final result = <Widget>[];

    for (var index = 0; index < provider.listTrail.length; index++) {
      if (index % 5 == 0) {
        result.add(provider.listTrail.elementAt(index));
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedCursorTrailProvider(),
      child: Consumer<AnimatedCursorTrailProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              if (child != null) child,
              Positioned.fill(
                child: MouseRegion(
                  onHover: (event) {
                    _onCursorUpdate(context, event);
                    provider.listTrail.add(
                      AnimatedTrail(offset: event.position),
                    );
                  },
                  opaque: false,
                ),
              ),
              ..._trail(provider),
            ],
          );
        },
        child: child,
      ),
    );
  }
}

class AnimatedCursorMouseRegion extends StatefulWidget {
  const AnimatedCursorMouseRegion({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<AnimatedCursorMouseRegion> createState() =>
      _AnimatedCursorMouseRegionState();
}

class _AnimatedCursorMouseRegionState extends State<AnimatedCursorMouseRegion> {
  late final AnimatedCursorTrailProvider _cubit;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _cubit = context.read<AnimatedCursorTrailProvider>();
  }

  @override
  void dispose() {
    _cubit.resetCursor();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      opaque: false,
      onHover: (_) => _cubit.changeCursor(_key),
      onExit: (_) => _cubit.resetCursor(),
      child: widget.child,
    );
  }
}

class AnimatedTrail extends StatefulWidget {
  const AnimatedTrail({
    super.key,
    required this.offset,
  });

  final Offset offset;

  @override
  State<AnimatedTrail> createState() => _AnimatedTrailState();
}

class _AnimatedTrailState extends State<AnimatedTrail> {
  double scaleValue = 1.0;

  void changeOpacity() {
    if (mounted) setState(() => scaleValue = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeOpacity();
    });

    return Positioned(
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: IgnorePointer(
        child: AnimatedScale(
          duration: const Duration(seconds: 2),
          curve: Curves.ease,
          scale: scaleValue,
          child: const Icon(
            Icons.favorite,
            color: Colors.purple,
            size: 20.0,
          ),
        ),
      ),
    );
  }
}
