class TimeLeft {
  String timeLeft(DateTime due) {
    String retVal;

    Duration _timeUntilDue = due.difference(DateTime.now());

    int _daysUntil = _timeUntilDue.inDays;
    int _hoursUntil = _timeUntilDue.inHours - (_daysUntil * 24);
    int _minUntil = _timeUntilDue.inMinutes - (_daysUntil * 24 * 60) - (_hoursUntil * 60);

    if (_daysUntil > 0) {
      retVal = _daysUntil.toString() +
          " dni\n" +
          _hoursUntil.toString() +
          " godzin\n" +
          _minUntil.toString() +
          " minut";
    } else if (_hoursUntil > 0) {
      retVal = _hoursUntil.toString() + " godzin\n" + _minUntil.toString() + " minut";
    } else if (_minUntil > 0) {
      retVal = _minUntil.toString() + " minut";
    } else if (_minUntil == 0) {
      retVal = "almost there ";
    } else {
      retVal = "error";
    }

    return retVal;
  }
}