import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime format() {
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    const timeSpecific = "10:40:00";
    final completeFormat = DateFormat('y/M/d H:m:s');

    final todayDate = dateFormat.format(now);
    final todayDateandTime = "$todayDate $timeSpecific";
    var resultToday = completeFormat.parseStrict(todayDateandTime);

    var formatted = resultToday.add(const Duration(days: 1));
    final tommorow = dateFormat.format(formatted);
    final tommorowDateAndTime = "$todayDate $timeSpecific";
    var ressultTommorow = completeFormat.parseStrict(tommorowDateAndTime);
    return now.isAfter(resultToday) ? ressultTommorow : resultToday;
  }
}
