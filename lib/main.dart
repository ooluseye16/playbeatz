import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
        create: (_) => SongProvider()),
        ChangeNotifierProvider(
        create: (_) => SongController(),
),
    ],
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
  final player = AudioPlayer();

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
        return GestureDetector(
          onTap:  () async{
            await player.setFilePath('${songs[index]['path']}');
            player.play();
          },
          onDoubleTap: () async{
            await player.pause();
          },
            onLongPress: () {
              player.stop();
            },
          child: ListTile(
            leading: Icon(Icons.more_vert),
            title: Text(songs[index]['title']),
            subtitle: Text(songs[index]['artist'])
          ),
        );
      }),
    );
  }
}

