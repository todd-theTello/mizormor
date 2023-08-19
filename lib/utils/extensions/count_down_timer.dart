///
extension Count on int {
  ///
  String get toFormatHHMMSS {
    int hours = (this / 3600).truncate();
    final int days = (this / (3600 * 24)).truncate();
    if (days != 0) {
      hours = hours % 24;
    }
    final int seconds = this % 3600;
    final int minutes = (seconds / 60).truncate();

    final String daysStr = (days).toString().padLeft(2, '0');
    final String hoursStr = (hours).toString().padLeft(2, '0');
    final String minutesStr = (minutes).toString().padLeft(2, '0');
    final String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (days == 0) {
      return '$hoursStr:$minutesStr:$secondsStr';
    } else if (hours == 0 && days == 0) {
      return '$minutesStr:$secondsStr';
    }

    return '$daysStr:$hoursStr:$minutesStr:$secondsStr';
  }
}
