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
  Destination(Icons.dynamic_form_rounded, 'Form'),
  Destination(Icons.article_outlined, 'List'),
  Destination(Icons.flutter_dash, 'Dash'),
];
