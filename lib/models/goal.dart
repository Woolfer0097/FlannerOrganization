import 'package:flutter/material.dart';

class Goal {
  final String id; // Unique identifier for the goal
  final String name; // Name of the goal (e.g., "No smoking")
  final String description; // Description of the goal
  final int targetCount; // Target count (e.g., 100 days)
  final DateTime startDate; // Start date of the goal

  Goal({
    required this.id,
    required this.name,
    required this.description,
    required this.targetCount,
    required this.startDate,
  });
}
