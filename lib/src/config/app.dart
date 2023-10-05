// This is how a shell route is implemented
// ShellRoute: is a container, basically, all the child routes
// will be rendered inside of its widget.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeNames = ['/', '/dash', '/loading'];
final navBarWidth = 255;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: routeNames.first,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Home(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: routeNames.first,
          builder: (context, state) {
            return Center(child: PerfumeForm());
          },
        ),
        GoRoute(
          path: '/dash',
          builder: (BuildContext context, GoRouterState state) {
            return WavePage();
          },
        ),
        GoRoute(
          path: '/loading',
          builder: (BuildContext context, GoRouterState state) {
            return LoadingPage();
          },
        ),
        GoRoute(
          path: '/perfume',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: PerfumePageContent(),
              opaque: false,
              transitionsBuilder: (context, animation, _, child) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: LayoutBuilder(builder: (context, constraints) {
                    // Adapted from : https://github.com/retroportalstudio/flutter_page_wave_transition
                    return TweenAnimationBuilder(
                      curve: Curves.easeOut,
                      duration: Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return ShaderMask(
                          blendMode: BlendMode.modulate,
                          shaderCallback: (rect) {
                            return RadialGradient(
                              radius: value * 5,
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.transparent,
                                Colors.transparent,
                              ],
                              stops: [0.0, 0.5, 0.6, 1.0],
                              center: FractionalOffset.bottomRight,
                            ).createShader(rect);
                          },
                          child: child,
                        );
                      },
                      child: child,
                    );
                  }),
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}
