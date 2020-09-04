import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Artists extends StatefulWidget {
  final List songList;

  const Artists({Key key, this.songList}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  List<Artist> artistList = [];

  getArtists() {
    var data = widget.songList;
    var newMap = groupBy(data, (obj) => obj['artist']);
    newMap.forEach((key, value) => artistList.add(Artist(
          name: key,
          values: value,
        )));
  }

  @override
  void initState() {
    super.initState();
    getArtists();
  }

  @override
  Widget build(BuildContext context) {
    artistList.sort((a, b) => a.name.compareTo(b.name));
    return SafeArea(
      child: Scaffold(
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  thickness: 2.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
            itemCount: artistList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage:
                      artistList[index].values[0]['artwork'] != null
                          ? MemoryImage(
                              artistList[index].values[0]['artwork'],
                            )
                          : null,
                  child: artistList[index].values[0]['artwork'] != null
                      ? null
                      : Text(artistList[index].values[0]['title'][0]),
                ),
                title: Text(artistList[index].name),
                subtitle: Text("${artistList[index].values.length} songs"),
              );
            }),
      ),
    );
  }
}

class Artist {
  final String name;
  final List values;

  Artist({this.name, this.values});
}
