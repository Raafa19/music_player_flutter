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
