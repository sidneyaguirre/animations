// This is how a shell route is implemented
// ShellRoute: is a container, basically, all the child routes
// will be rendered inside of its widget.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeNames = ['/', '/list', '/dash'];

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
          path: '/perfume',
          builder: (BuildContext context, GoRouterState state) {
            return Center(
              child: PerfumeSelection(),
            );
          },
        ),
        GoRoute(
          path: '/list',
          builder: (BuildContext context, GoRouterState state) {
            return Center(child: const ListOfElements());
          },
        ),
        GoRoute(
          path: '/dash',
          builder: (BuildContext context, GoRouterState state) {
            return Wave(size: MediaQuery.sizeOf(context));
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
