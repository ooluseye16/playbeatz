import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playbeatz/components/customButton.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:playbeatz/screens/albums.dart';
import 'package:provider/provider.dart';

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final player = AudioPlayer();
  bool isPlaying = false;

  getSongs() async {
    await Provider.of<SongProvider>(context, listen: false).getAllSongs();
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Albums(
                            songList: songs,
                          )),
                );
              },
              child: Text(
                "A",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          )
        ],
      ),
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
                  title: Text(songs[index]['title']),
                  subtitle: Text(songs[index]['albumArtist']),
                  trailing: CustomButton(
                    child:
                        controller.nowPlaying['path'] == songs[index]['path'] &&
                                isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                    diameter: 12,
                    isToggled:
                        controller.nowPlaying['path'] == songs[index]['path'],
                    onPressed: () async {
                      controller.allSongs = songs;
                      await controller.playlistControlOptions(songs[index]);
                      setState(() {
                        isPlaying = controller.isPlaying;
                      });
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
