import 'package:flutter/material.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:playbeatz/screens/home.dart';
import 'package:provider/provider.dart';
import 'models/playlistDB.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SongProvider()),
        ChangeNotifierProvider(
          create: (_) => SongController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayListDB(),
        )
      ],
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}
