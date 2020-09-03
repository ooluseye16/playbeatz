import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class Albums extends StatefulWidget {
  final List songList;

  Albums({this.songList});

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  List<Widget> albumList = [];

  getAlbums() {
    var data = widget.songList;
    var newMap = groupBy(data, (obj) => obj['album']);
    newMap.forEach((key, value) => albumList.add(ListTile(
          title: Text(key),
          subtitle: Text("${value.length} songs"),
        )));
  }

  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(itemBuilder: (context, index) {
          return albumList[index];
        }),
      ),
    );
  }
}
