import 'package:ai_study/app/domain/models/badge_model.dart';
import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final BadgeModel badge;

  const BadgeWidget({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(badge.icon, size: 50, color: Colors.amber),
        SizedBox(height: 8),
        Text(
          textAlign: TextAlign.center,
          badge.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
