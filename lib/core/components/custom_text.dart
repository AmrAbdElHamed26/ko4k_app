import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customText(String data,
        {Color color = Colors.black, double fontSize = 16 , FontWeight fontWeight = FontWeight.normal}) =>
    Text(
      data,
      style: TextStyle(color: color, fontSize: fontSize , fontWeight: fontWeight , overflow: TextOverflow.ellipsis),
    );
