import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playbeatz/components/customButton.dart';
//import 'package:playbeatz/components/customButton.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';


class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    return Scaffold(
      body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return Consumer<SongController>(
              builder: (context, controller, child) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: songs[index]['artwork'] != null
                        ? MemoryImage(
                            songs[index]['artwork'],
                          )
                        : null,
                    child: songs[index]['artwork'] != null
                        ? null
                        : Text(songs[index]['title'][0]),
                  ),
                  title: Text(
                    songs[index]['title'],
                    maxLines: 1,
                  ),
                  subtitle: Text(songs[index]['artist']),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Color(0xff254bc8).withOpacity(0.7),
                    ),
                    onPressed: () {},
                  ),
                  onTap: () async {
                    controller.allSongs = songs;
                    await controller.playlistControlOptions(songs[index]);
                    setState(() {
                      isPlaying = controller.isPlaying;
                    });
                  },
                );
              },
            );
          }),
    );
  }
}
