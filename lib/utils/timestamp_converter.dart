import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toFormattedTime(int seconds, int nanoseconds) {
    // Combine seconds and nanoseconds into milliseconds
    int milliseconds = seconds * 1000 + (nanoseconds ~/ 1000000);

    // Create a DateTime object from millisecondsSinceEpoch
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Format the DateTime object into a time string (e.g., "12:00 pm")
    return DateFormat.jm().format(dateTime);
  }
}