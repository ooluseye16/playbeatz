import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/constants.dart';
import 'package:playbeatz/screens/playlist.dart';

class Albums extends StatefulWidget {
  final List songList;

  Albums({this.songList});

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List<Album> albumList = [];
  ScrollController _controller;

  getAlbums() {
    var data = widget.songList;
    var newMap = groupBy(data, (obj) => obj['album']);
    newMap.forEach((key, value) => albumList.add(Album(
          title: key,
          values: value,
        )));
  }

  @override
  void initState() {
    super.initState();
    getAlbums();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    albumList.sort((a, b) => a.title.compareTo(b.title));
    return SafeArea(
      child: Scaffold(
        body: Scrollbar(
          controller: _controller,
          child: ListView.builder(
              itemCount: albumList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Playlist(
                                  songList: albumList[index].values,
                                )));
                  },
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: albumList[index].values[0]['artwork'] !=
                        null
                        ? MemoryImage(
                      albumList[index].values[0]['artwork'],
                    )
                        : null,
                    child: albumList[index].values[0]['artwork'] != null
                        ? null
                        : Text(albumList[index].values[0]['title'][0]),
                  ),
                  title: Text(albumList[index].title),
                  subtitle: Text(
                    "${albumList[index].values.length} songs",
                    style: textStyle,),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert,
                      color: Color(0xff254bc8).withOpacity(0.7),),
                    onPressed: () {},
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class Album {
  final String title;
  final List values;

  Album({this.title, this.values});
}
