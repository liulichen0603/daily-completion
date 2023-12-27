// datetime_utils.dart

class DateTimeUtils {
  static bool isSameDay(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  static bool isSameMonth(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year && dt1.month == dt2.month;
  }

  static bool isSameYear(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year;
  }

  static bool isSameWeek(DateTime dt1, DateTime dt2) {
    if (dt1.year != dt2.year) {
      return false;
    }

    int weekNumber1 = dt1.difference(DateTime(dt1.year, 1, 1)).inDays ~/ 7;
    int weekNumber2 = dt2.difference(DateTime(dt2.year, 1, 1)).inDays ~/ 7;
    return weekNumber1 == weekNumber2;
  }
}
