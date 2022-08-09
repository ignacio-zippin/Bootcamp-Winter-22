import 'package:intl/intl.dart';

String timeFormatHHMM24Hours(DateTime time) {
  return DateFormat("HH:mm").format(time);
}

String numberFormatXX(int number) {
  return number.toString().padLeft(2, "0");
}
