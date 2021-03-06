import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/components/playingButton.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'nowPlaying.dart';

class Playlist extends StatefulWidget {
  final List songList;
  final String playlistName;

  Playlist({this.songList, this.playlistName});

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
        title: widget.playlistName == null
            ? Text("Playlist")
            : Text(widget.playlistName),
        centerTitle: true,
        gradient: gradient,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              //TODO: implement material searchBar
            },
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
                    onTap: () async {
                      controller.allSongs = songs;
                      await controller.playlistControlOptions(songs[index]);
                      setState(() {
                        isPlaying = controller.isPlaying;
                        songs[index]['numOfPlay']++;
                      });
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NowPlaying(
                              currentSong: currentSong,
                              songList: songs,
                            )),
                      );
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
                        fontWeight: FontWeight.w400,
                        color: controller.nowPlaying['path'] ==
                            songs[index]['path']
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
                            songs[index]['path']
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        controller.nowPlaying['path'] == songs[index]['path'] &&
                            controller.isPlaying
                            ? Icons.equalizer
                            : Icons.more_vert,
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
                              songList: songs,
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
                      color: controller.isShuffled ? Colors.black : Colors.grey,
                      onPressed: () {
                          controller.shuffle(songs);
                          controller.settings(
                              shuffle: !controller.isShuffled);
                          SharedPreferences.getInstance().then((pref) {
                            pref.setBool('shuffle', controller.isShuffled);
                            pref.setBool('repeat', controller.isRepeat);
                          });
                        }
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
                      color: controller.isRepeat ? Colors.black : Colors.grey,
                      onPressed: () {
                        controller.settings(
                          repeat: !controller.isRepeat,
                        );
                        SharedPreferences.getInstance().then((pref) {
                          pref.setBool('shuffle', controller.isShuffled);
                          pref.setBool('repeat', controller.isRepeat);
                        });
                      },
                    ),
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
