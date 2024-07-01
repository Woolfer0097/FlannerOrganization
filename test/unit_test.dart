import 'package:flutter_test/flutter_test.dart';

class Habit {
  final String name;

  Habit(this.name);
}

int calculateTotalHabits(List<Habit> habits) {
  return habits.length;
}

void main() {
  test('Calculate total habits', () {
    // Test case 1: Calculate total habits in an empty list
    List<Habit> emptyList = [];
    expect(calculateTotalHabits(emptyList), 0);

    // Test case 2: Calculate total habits in a list with one habit
    List<Habit> oneHabitList = [Habit('Exercise')];
    expect(calculateTotalHabits(oneHabitList), 1);

    // Test case 3: Calculate total habits in a list with multiple habits
    List<Habit> multipleHabitsList = [
      Habit('Exercise'),
      Habit('Read'),
      Habit('Meditate'),
    ];
    expect(calculateTotalHabits(multipleHabitsList), 3);
  });
}
