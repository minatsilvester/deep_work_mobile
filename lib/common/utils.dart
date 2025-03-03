import 'package:flutter/material.dart';

String formatDateTime(String dateTime) {
  return dateTime.split('T').join(' ');
}

Color setColor(String status) {
  switch (status) {
    case 'inprogress':
      return const Color.fromARGB(255, 185, 167, 9);
    case 'cancelled':
      return const Color.fromARGB(255, 159, 26, 17);
    case 'completed':
      return Colors.green;
    default:
      return const Color.fromARGB(255, 185, 167, 9);
  }
}

String capitalize(string) {
  return "${string[0].toUpperCase()}${string.substring(1)}";
}

bool isFocusSessionCompleted(focusSession) {
  return focusSession.status == "completed";
}
