class DailyProgress {
  final String habitId; // ID of the habit associated with this progress
  final DateTime date; // Date for which this progress is recorded
  final bool completed; // Whether the habit was completed on this date
  final bool skipped; // Whether the habit was skipped on this date

  DailyProgress({
    required this.habitId,
    required this.date,
    this.completed = false,
    this.skipped = false,
  });
}
