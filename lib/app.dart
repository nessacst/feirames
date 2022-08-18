import 'package:anotations/modo_dark.dart';
import 'package:anotations/tabs/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemaProvedor(),
      child: Consumer<ThemaProvedor>(
        builder: (context, mode, child) {
          return MultiProvider(
            providers: [],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Home(),
            ),
          );
        },
      ),
    );
  }
}
