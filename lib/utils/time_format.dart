import 'package:intl/intl.dart';

import '../models/clock_settings.dart';

class TimeFormat {
  const TimeFormat._();

  static String hours(DateTime dateTime, ClockSettings settings) {
    if (settings.use24HourFormat) {
      return DateFormat('HH').format(dateTime);
    }
    return DateFormat('hh').format(dateTime);
  }

  static String minutes(DateTime dateTime) => DateFormat('mm').format(dateTime);

  static String seconds(DateTime dateTime) => DateFormat('ss').format(dateTime);

  static String amPm(DateTime dateTime) => DateFormat('a').format(dateTime);

  static String date(DateTime dateTime) =>
      DateFormat('MMMM d, y').format(dateTime);

  static String weekday(DateTime dateTime) =>
      DateFormat('EEEE').format(dateTime);
}
