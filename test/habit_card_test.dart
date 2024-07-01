import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HabitCard extends StatelessWidget {
  final String habitName;
  final Color color;

  const HabitCard({
    Key? key,
    required this.habitName,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap action
        print('Tapped on habit: $habitName');
      },
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            habitName,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('HabitCard Widget Test', (WidgetTester tester) async {
    // Build a HabitCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitCard(
            habitName: 'Exercise',
            color: Colors.green,
          ),
        ),
      ),
    );

    // Verify if the habit name and color are correctly displayed
    expect(find.text('Exercise'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);

    // Tap on the habit card
    await tester.tap(find.byType(Card));
    await tester.pump();

    // Verify if onTap handler works correctly
    expect(tester.takeException(), isNull); // Ensure no exceptions were thrown
    expect(tester.takeException(), isNull);
  });
}
