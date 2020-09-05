import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/screens/playlist.dart';

class Genres extends StatefulWidget {
  final List songList;

  const Genres({Key key, this.songList}) : super(key: key);

  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  List<Genre> genreList = [];

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
  }

  @override
  Widget build(BuildContext context) {
    genreList.sort((a, b) => a.name.compareTo(b.name));
    return SafeArea(
      child: Scaffold(
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  thickness: 2.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
            itemCount: genreList.length,
            itemBuilder: (context, index) {
              var data = genreList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Playlist(
                                songList: data.values,
                              )));
                },
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: data.values[0]['artwork'] != null
                      ? MemoryImage(
                          data.values[0]['artwork'],
                        )
                      : null,
                  child: data.values[0]['artwork'] != null
                      ? null
                      : Text(data.values[0]['title'][0]),
                ),
                title: Text(data.name),
                subtitle: Text("${data.values.length} songs"),
              );
            }),
      ),
    );
  }
}

class Genre {
  final String name;
  final List values;

  Genre({this.name, this.values});
}
