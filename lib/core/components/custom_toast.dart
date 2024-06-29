import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, {required Color backgroundColor, Color textColor = Colors.white}) {
      Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: backgroundColor,
            textColor: textColor,
            fontSize: 16,
      );
}

void showErrorToast(String msg, {Color color = Colors.red}) {
      showToast(msg, backgroundColor: color);
}

void showSuccessToast(String msg, {Color color = Colors.green}) {
      showToast(msg, backgroundColor: color);
}
