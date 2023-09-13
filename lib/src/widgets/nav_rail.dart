import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    required this.backgroundColor,
    this.onDestinationSelected,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.selectedIndex,
  });

  final Color backgroundColor;
  final ValueChanged<int>? onDestinationSelected;
  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: backgroundColor,
      child: NavigationRail(
        extended: true,
        selectedIndex: selectedIndex,
        backgroundColor: backgroundColor,
        onDestinationSelected: onDestinationSelected,
        groupAlignment: -0.85,
        destinations: destinations.map((d) {
          return NavigationRailDestination(
            icon: Icon(d.icon),
            label: Text(d.label),
          );
        }).toList(),
      ),
    );
  }
}
