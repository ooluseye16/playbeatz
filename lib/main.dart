import 'package:flutter/material.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:playbeatz/screens/playbeatz.dart';
import 'package:playbeatz/utilities/dark_mode_style.dart';
import 'package:provider/provider.dart';
import 'models/playlistDB.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => SongProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => SongController(),
    ),
    ChangeNotifierProvider(
      create: (_) => PlayListDB(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<SongProvider>(context);
    return MaterialApp(
      title: 'PlayBeatz',
      theme: ThemeData(
        canvasColor: Styles.themeData(themeChange.darkTheme, context).color1,
        scaffoldBackgroundColor:
            Styles.themeData(themeChange.darkTheme, context).color1,
      ),
      home: PlayBeatz(),
    );
  }
}
