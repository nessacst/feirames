import 'package:anotations/app.dart';
import 'package:anotations/tabs/home.dart';
import 'package:flutter/material.dart';

import 'page/inicial.dart';
import 'modo_dark.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}
