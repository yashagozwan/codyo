import 'package:bcrypt/bcrypt.dart' show BCrypt;
import 'package:flutter/material.dart' show Colors;
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast;
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:timeago/timeago.dart' as timeago;

class Util {
  static String hashPassword(String password) {
    final salt = BCrypt.gensalt();
    return BCrypt.hashpw(password, salt);
  }

  static bool verifyPassword(String password, String hashed) {
    return BCrypt.checkpw(password, hashed);
  }

  static String dateFormatter(int createdAt) {
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return DateFormat.yMMMMd().format(date);
  }

  static String dateFormatterFull(int createdAt) {
    final date = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return DateFormat.jms().addPattern(' - ').add_yMMMMEEEEd().format(date);
  }

  static void showToastSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.green,
    );
  }

  static void showToastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
    );
  }

  static String currencyFormatter(int price) {
    final format = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return format.format(price);
  }

  static String timeAgo(int createdAt) {
    final productCreatedAt = DateTime.fromMillisecondsSinceEpoch(createdAt);
    return timeago.format(productCreatedAt);
  }
}
