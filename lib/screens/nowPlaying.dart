import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/components/playingButton.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

class NowPlaying extends StatefulWidget {
  final currentSong;
  final songList;

  NowPlaying({this.currentSong, this.songList});

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  bool isPlaying = false;
  dynamic currentSong;
  dynamic nowPlaying;
  SongController player;

  Future<void> setUpPlayer() async {
    player = Provider.of<SongController>(context, listen: false);
    if (player.nowPlaying['path'] == null) {
      await player.setUp(widget.currentSong);
    } else if (player.nowPlaying['path'] != widget.currentSong['path']) {
      player.disposePlayer();
      nowPlaying = widget.currentSong;
      await player.setUp(nowPlaying);
    }
  }

  @override
  void initState() {
    setUpPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var songs = widget.songList;
    return Consumer<SongController>(
      builder: (context, controller, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff254bc8).withOpacity(0.7),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Column(
                children: [
                  Text(
                    "Playlist",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    controller.nowPlaying['album'],
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.more_vert,
                      color: Color(0xff254bc8).withOpacity(0.7)),
                  onPressed: () {},
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 38, right: 37, top: 10.0, bottom: 10.0),
                      child: controller.nowPlaying['artwork'] != null
                          ? Image.memory(
                        controller.nowPlaying['artwork'],
                        fit: BoxFit.fill,
                      )
                          : Text("No Artwork"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              controller.nowPlaying['title'],
                              //overflow: TextOverflow.ellipsis,
                              // maxLines: 1,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Text(
                            controller.nowPlaying['artist'],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          Text(
                            "Lyrics",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.tune,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        PlayingButton(
                          icon: Icons.shuffle,
                          color: controller.isShuffled
                              ? Colors.black
                              : Colors.grey,
                          onPressed: () async {
                            await controller.shuffle(songs);
                            controller.settings(
                                shuffle: !controller.isShuffled);
                          },
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
                              controller.allSongs = Provider.of<SongProvider>(
                                  context,
                                  listen: false)
                                  .allSongs;
                              controller.setUp(currentSong);
                            } else {
                              isPlaying
                                  ? controller.pause()
                                  : controller.play();
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
                          color:
                          controller.isRepeat ? Colors.black : Colors.grey,
                          onPressed: () {
                            controller.settings(
                              repeat: !controller.isRepeat,
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
