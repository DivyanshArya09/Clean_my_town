extension DateTimeFormatter on DateTime {
  String toTime() {
    String day = this.day.toString();
    String month = this.month.toString();
    String year = this.year.toString();

    String hour = (this.hour % 12 == 0) ? "12" : (this.hour % 12).toString();
    String minute = this.minute.toString().padLeft(2, '0');
    String amPm = (this.hour < 12) ? 'AM' : 'PM';

    return '$day/$month/$year, $hour:$minute $amPm';
  }
}
