import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  const Config({Key? key}) : super(key: key);

  @override
  State<Config> createState() => _ConfigState();
}

// ThemeController modoDark = ThemeController();

class _ConfigState extends State<Config> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    //  final themeProvider = Provider.of<ThemeMode>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
          backgroundColor: Colors.cyan,
        ),
        body: Text("tedty"));
  }

  @override
  bool get wantKeepAlive => true;
}
