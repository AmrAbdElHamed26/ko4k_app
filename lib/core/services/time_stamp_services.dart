import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeStampServices {
  // Private constructor
  TimeStampServices._privateConstructor();

  // The single instance of the class
  static final TimeStampServices _instance = TimeStampServices._privateConstructor();

  // Factory constructor to return the same instance every time
  factory TimeStampServices() {
    return _instance;
  }

  // Method to convert Timestamp to formatted date string
  String convertTimeStampToDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d-M-yyyy').format(dateTime);
  }

  Timestamp convertStringToTimestamp(String timestampString) {
    final regex = RegExp(r'Timestamp\(seconds=(\d+), nanoseconds=(\d+)\)');
    final match = regex.firstMatch(timestampString);

    if (match != null) {
      final seconds = int.parse(match.group(1)!);
      final nanoseconds = int.parse(match.group(2)!);
      return Timestamp(seconds, nanoseconds);
    } else {
      throw FormatException("Invalid timestamp format");
    }
  }
}

