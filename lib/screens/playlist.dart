import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:playbeatz/components/customButton.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

class Playlist extends StatefulWidget {
  final List songList;

  Playlist({this.songList});

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    var songs = widget.songList;
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
