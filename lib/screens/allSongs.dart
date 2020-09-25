import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

import 'nowPlaying.dart';


class AllSongs extends StatefulWidget {
  final List songList;
  AllSongs({this.songList});
  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  bool isPlaying = false;
  dynamic currentSong;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    songs.sort((a,b) => a['title'].compareTo(b['title']));
    return Scaffold(
      body: Scrollbar(
        controller: _controller,
        child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Consumer<SongController>(
                builder: (context, controller, child) {
                  currentSong = controller.nowPlaying['path'] == null
                      ? currentSong
                      : controller.nowPlaying;
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
                  );
                },
              );
            }),
      ),
    );
  }
}
