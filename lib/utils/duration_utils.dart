String secondsToMinutes(int seconds) {
  int mins = Duration(milliseconds: seconds).inMinutes;
  String minString;
  if (mins > 9) {
    minString = mins.toString();
  } else {
    minString = "0$mins";
  }
  int rem = ((seconds / 1000) - (mins * 60)).toInt();
  String remString;

  if (rem > 9) {
    remString = rem.toString();
  } else {
    remString = "0$rem";
  }

  return "$minString:$remString";
}

String durationToString(Duration? duration) {
  if (duration == null) {
    return "";
  }
  const int minutesPerHour = 60;
  const int millisecondsPerSecond = 1000;
  const int microsecondsPerMillisecond = 1000;
  const int secondsPerMinute = 60;

  const int microsecondsPerSecond =
      microsecondsPerMillisecond * millisecondsPerSecond;
  const int microsecondsPerMinute = microsecondsPerSecond * secondsPerMinute;

  const int microsecondsPerHour = microsecondsPerMinute * minutesPerHour;

  var microseconds = duration.inMicroseconds;

  var hours = microseconds ~/ microsecondsPerHour;
  microseconds = microseconds.remainder(microsecondsPerHour);

  var minutes = microseconds ~/ microsecondsPerMinute;
  microseconds = microseconds.remainder(microsecondsPerMinute);

  var minutesPadding = minutes < 10 ? "0" : "";

  var seconds = microseconds ~/ microsecondsPerSecond;
  microseconds = microseconds.remainder(microsecondsPerSecond);

  var secondsPadding = seconds < 10 ? "0" : "";

  String hoursText = hours > 0 ? "${hours.toString()}:" : "";

  return "$hoursText"
      "$minutesPadding$minutes:"
      "$secondsPadding$seconds";
}
