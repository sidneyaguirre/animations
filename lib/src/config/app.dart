// This is how a shell route is implemented
// ShellRoute: is a container, basically, all the child routes
// will be rendered inside of its widget.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeNames = [
  '/',
  '/recipes',
  '/dash',
];
final navBarWidth = 255;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Home(
          route: state.uri,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return Center(child: PerfumeForm());
          },
        ),
        GoRoute(
          path: '/dash',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              child: DashPage(),
              opaque: false,
              transitionsBuilder: (context, animation, _, child) {
                return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: LayoutBuilder(builder: (context, constraints) {
                    return Wave(
                      size: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      child: child,
                    );
                  }),
                );
              },
            );
          },
        ),
        GoRoute(
          path: '/recipes',
          builder: (BuildContext context, GoRouterState state) {
            return RecipeListPage();
          },
        ),
        GoRoute(
          path: '/recipe-details/:id',
          builder: (BuildContext context, GoRouterState state) {
            return RecipeDetailsPage(
              id: state.pathParameters['id']!,
              recipe: state.extra as Recipe,
            );
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
                    return Wave(
                      size: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      child: ConstrainedBox(
                        constraints: constraints,
                        child: child,
                      ),
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
