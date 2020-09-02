import 'package:flutter/material.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SongProvider(),
      child: MaterialApp(
        home: MusicApp(),
      ),
    );
  }
}


class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {

  getSongs() async{
    await Provider.of<SongProvider>(context, listen: false).getAllSongs();
  }
@override
  void initState(){
    super.initState();
  getSongs();
  }
  @override
  Widget build(BuildContext context){
     List songs = Provider.of<SongProvider>(context).allSongs;
    return Scaffold(
      body:ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.more_vert),
          title: Text(songs[index]['title']),
          subtitle: Text(songs[index]['artist'])
        );
      }),
    );
  }
}

