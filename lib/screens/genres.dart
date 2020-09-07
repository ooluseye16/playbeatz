import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/screens/playlist.dart';

import '../constants.dart';

class Genres extends StatefulWidget {
  final List songList;

  const Genres({Key key, this.songList}) : super(key: key);

  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  List<Genre> genreList = [];
  ScrollController _controller;

  getGenres() {
    var data = widget.songList;
    var newMap = groupBy(data, (obj) => obj['genre']);
    newMap.forEach((key, value) => genreList.add(Genre(
          name: key,
          values: value,
        )));
  }

  @override
  void initState() {
    super.initState();
    getGenres();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    genreList.sort((a, b) => a.name.compareTo(b.name));
    return SafeArea(
      child: Scaffold(
        body: Scrollbar(
          controller: _controller,
          child: ListView.builder(
              itemCount: genreList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Playlist(
                                  songList: genreList[index].values,
                                )));
                  },
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: genreList[index].values[0]['artwork'] !=
                        null
                        ? MemoryImage(
                      genreList[index].values[0]['artwork'],
                    )
                        : null,
                    child: genreList[index].values[0]['artwork'] != null
                        ? null
                        : Text(genreList[index].values[0]['title'][0]),
                  ),
                  title: Text(genreList[index].name),
                  subtitle: Text(
                    "${genreList[index].values.length} songs",
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

class Genre {
  final String name;
  final List values;

  Genre({this.name, this.values});
}
