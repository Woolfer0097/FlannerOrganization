class Habit {
  final String id; // Unique identifier for the habit
  final String name; // Name of the habit
  final String description; // Description of the habit
  final String icon; // Optional: Icon to represent the habit
  final List<DayOfWeek> activeDays; // Days of the week when the habit is active
  final int goal; // Optional: Goal for the habit (e.g., streak goal)

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.activeDays,
    this.icon = '',
    this.goal = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'activeDays': activeDays.map((day) => day.index).toList(),
      'icon': icon,
      'goal': goal,
    };
  }

  Habit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        activeDays = List<DayOfWeek>.from(
            json['activeDays'].map((day) => DayOfWeek.values[day])),
        icon = json['icon'] ?? '',
        goal = json['goal'] ?? 0;
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
