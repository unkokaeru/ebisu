import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/string_constants.dart';

/// Utility class for date and time operations.
class DateTimeUtilities {
  DateTimeUtilities._();

  /// Check if two dates are the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if a date is today.
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if a date is yesterday.
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Get the start of the day for a given date.
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day for a given date.
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Check if it's morning time (5am - 12pm).
  static bool isMorningTime() {
    final hour = DateTime.now().hour;
    return hour >= NumericConstants.morningStartHour &&
        hour < NumericConstants.morningEndHour;
  }

  /// Check if it's evening time (5pm - 11pm).
  static bool isEveningTime() {
    final hour = DateTime.now().hour;
    return hour >= NumericConstants.eveningStartHour &&
        hour < NumericConstants.eveningEndHour;
  }

  /// Get appropriate greeting based on time of day.
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= NumericConstants.morningStartHour && hour < NumericConstants.morningEndHour) {
      return StringConstants.homeGreetingMorning;
    } else if (hour >= NumericConstants.eveningStartHour) {
      return StringConstants.homeGreetingEvening;
    } else {
      return StringConstants.homeGreetingAfternoon;
    }
  }

  /// Calculate streak based on last active date.
  static int calculateStreak(DateTime lastActiveDate, int currentStreak) {
    final today = startOfDay(DateTime.now());
    final lastActive = startOfDay(lastActiveDate);
    final difference = today.difference(lastActive).inDays;

    if (difference == 0) {
      return currentStreak;
    } else if (difference == 1) {
      return currentStreak + 1;
    } else {
      return 1;
    }
  }

  /// Check if streak should be broken.
  static bool isStreakBroken(DateTime lastActiveDate) {
    final today = startOfDay(DateTime.now());
    final lastActive = startOfDay(lastActiveDate);
    final difference = today.difference(lastActive).inDays;
    return difference > 1;
  }

  /// Get relative date string (Today, Yesterday, or formatted date).
  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return StringConstants.today;
    } else if (isYesterday(date)) {
      return StringConstants.yesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Get list of dates for the past N days.
  static List<DateTime> getLastNDays(int count) {
    final today = startOfDay(DateTime.now());
    return List.generate(count, (index) => today.subtract(Duration(days: index)))
        .reversed
        .toList();
  }
}
