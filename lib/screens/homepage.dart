import 'package:flutter/material.dart';
import 'package:playbeatz/components/customListView.dart';
import 'package:playbeatz/models/playlistDB.dart';
import 'package:playbeatz/models/provider.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final List songList;
  HomePage({this.songList});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    List recentSongs = Provider.of<PlayListDB>(context).recentList;

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trending",
                    style: TextStyle(
                        color: Color(0xff254bc8).withOpacity(0.7),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomListView(
                      songList: songs,
                      width: 300.0,
                      sortBy: 'numOfPlay',
                    ),
                  ),
                  Text(
                    "Recently Added",
                    style: TextStyle(
                        color: Color(0xff254bc8).withOpacity(0.7),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomListView(
                      songList: songs,
                      width: 150.0,
                      sortBy: 'recentlyAdded',
                    ),
                  ),
                  Text(
                    "Recently Played",
                    style: TextStyle(
                        color: Color(0xff254bc8).withOpacity(0.7),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:  CustomListView(
                      songList: recentSongs,
                      width: 150.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
