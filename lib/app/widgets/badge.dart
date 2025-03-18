import 'package:flutter/material.dart';

class Badge {
  final String name;
  final String icon;

  Badge({required this.name, required this.icon});
}

class BadgeWidget extends StatelessWidget {
  final Badge badge;

  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Icon(Icons.star, color: Colors.amber), Text(badge.name)],
    );
  }
}
