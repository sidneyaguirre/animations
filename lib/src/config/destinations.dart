import 'package:flutter/material.dart';

class Destination {
  const Destination(
    this.icon,
    this.label,
  );

  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.account_tree_outlined, 'Form'),
  Destination(Icons.food_bank_outlined, 'Hero'),
  Destination(Icons.flutter_dash, 'Dash'),
];
