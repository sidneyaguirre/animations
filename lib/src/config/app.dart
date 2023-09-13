// This is how a shell route is implemented
// ShellRoute: is a container, basically, all the child routes
// will be rendered inside of its widget.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeNames = ['/', '/a', '/perfume'];

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
            return Center(child: FormScreen());
          },
        ),
        GoRoute(
          path: '/perfume',
          builder: (BuildContext context, GoRouterState state) {
            return Center(
              child: Image.network(
                'https://fimgs.net/mdimg/perfume/375x500.53675.jpg',
              ),
            );
          },
        ),
        GoRoute(
          path: '/a',
          builder: (BuildContext context, GoRouterState state) {
            return Center(child: const Text('Child Route "/b"'));
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
