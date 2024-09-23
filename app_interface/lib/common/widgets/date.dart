import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  // Define the desired date format
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  // Format the date
  return formatter.format(date);
}
