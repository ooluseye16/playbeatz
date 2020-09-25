import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/models/playlistDB.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'playbeatz.dart';

class AddToPlaylist extends StatefulWidget {
  final String playlistName;

  AddToPlaylist({Key key, this.playlistName});

  @override
  _AddToPlaylistState createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  bool isChecked = false;
  List playlist = [];
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    return Scaffold(
      appBar: GradientAppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.playlistName),
        centerTitle: true,
        gradient: gradient,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {
                Provider.of<PlayListDB>(context, listen: false)
                    .createPlaylist(widget.playlistName, playlist);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => PlayBeatz()));
                for (var song in playlist) {
                  setState(() {
                    song['isAdded'] = false;
                  });
                }
              },
              child: Text(
                "DONE",
              ),
            ),
          )
        ],
      ),
      body: Scrollbar(
        controller: _controller,
        child: ListView.builder(
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
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: controller.nowPlaying['path'] ==
                                    songs[index]['path'] &&
                                controller.isPlaying
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      songs[index]['artist'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: controller.nowPlaying['path'] ==
                            songs[index]['path'] &&
                            controller.isPlaying
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        songs[index]['isAdded'] == true
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Color(0xff254bc8).withOpacity(0.7),
                      ),
                      onPressed: () {
                        if (songs[index]['isAdded'] == true) {
                          playlist.remove(songs[index]);
                        } else {
                          playlist.add(songs[index]);
                        }
                        setState(() {
                          songs[index]['isAdded'] = !songs[index]['isAdded'];
                        });
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
