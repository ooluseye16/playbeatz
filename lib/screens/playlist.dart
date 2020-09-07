import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/components/playingButton.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'nowPlaying.dart';

class Playlist extends StatefulWidget {
  final List songList;

  Playlist({this.songList});

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool isPlaying = false;
  ScrollController _controller;
  dynamic currentSong;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var songs = widget.songList;
    return Scaffold(
      appBar: GradientAppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Playlist"),
        centerTitle: true,
        gradient: gradient,
        automaticallyImplyLeading: false,
      ),
      body: Scrollbar(
        controller: _controller,
        child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Consumer<SongController>(
                builder: (context, controller, child) {
                  return ListTile(
                    onTap: () async {
                      songs[index]['numofPlay']++;
                      controller.allSongs = songs;
                      await controller.playlistControlOptions(songs[index]);
                      setState(() {
                        isPlaying = controller.isPlaying;
                      });
                    },
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
                        controller.nowPlaying['path'] ==
                            songs[index]['path'] &&
                            controller.isPlaying
                            ? Icons.equalizer : Icons.more_vert,
                        color: Color(0xff254bc8).withOpacity(0.7),
                      ),
                      onPressed: () {},
                    ),
                  );
                },
              );
            }),
      ),
      bottomNavigationBar: Container(
        height: 70.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.2),
            blurRadius: 4,
          ),
        ]),
        child: Consumer<SongController>(
          builder: (context, controller, child) {
            isPlaying = controller.isPlaying;
            currentSong = controller.nowPlaying['path'] == null
                ? currentSong
                : controller.nowPlaying;
            return GestureDetector(
              onTap: () {
// if the list or playlist name empty (when the app is opened) use all songs
                controller.allSongs = controller.allSongs == null
                    ? Provider.of<SongProvider>(context, listen: false).allSongs
                    : controller.allSongs;
                controller.playlistName = controller.playlistName == null
                    ? 'All songs'
                    : controller.playlistName;
                if (currentSong != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NowPlaying(
                              currentSong: currentSong,
                            )),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                color: Theme.of(context).scaffoldBackgroundColor,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PlayingButton(
                      icon: Icons.shuffle,
                      onPressed: () async {},
                    ),
                    PlayingButton(
                      icon: Icons.skip_previous,
                      onPressed: () async {
                        await controller.skip(prev: true);
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [
                                0.1,
                                0.9
                              ],
                              colors: [
                                Colors.blue,
                                Color(0xff254bc8).withOpacity(0.7)
                              ]),
                        ),
                        child: Center(
                            child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 25.0,
                        )),
                      ),
                      onTap: () {
                        if (controller.nowPlaying['path'] == null) {
                          controller.allSongs =
                              Provider.of<SongProvider>(context, listen: false)
                                  .allSongs;
                          controller.setUp(currentSong);
                        } else {
                          isPlaying ? controller.pause() : controller.play();
                          setState(() {
                            isPlaying = controller.isPlaying;
                          });
                        }
                      },
                    ),
                    PlayingButton(
                      icon: Icons.skip_next,
                      onPressed: () async {
                        await controller.skip(next: true);
                      },
                    ),
                    PlayingButton(
                      icon: Icons.repeat,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

