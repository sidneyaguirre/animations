import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({
    super.key,
    this.onDestinationSelected,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.selectedIndex,
  });

  final ValueChanged<int>? onDestinationSelected;
  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final color = Colors.black87;

    return NavRailTransition(
      animation: railAnimation,
      backgroundColor: Colors.deepPurple.shade100,
      child: NavigationRail(
        extended: true,
        selectedIndex: selectedIndex,
        backgroundColor: Colors.deepPurple.shade100,
        onDestinationSelected: onDestinationSelected,
        groupAlignment: -0.85,
        destinations: destinations.map((d) {
          return NavigationRailDestination(
            icon: Icon(
              d.icon,
              color: color,
            ),
            label: Text(
              d.label,
              style: TextStyle(
                color: color,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
