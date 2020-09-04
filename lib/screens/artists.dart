import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/screens/playlist.dart';

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
              var data = artistList[index];
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

class Artist {
  final String name;
  final List values;

  Artist({this.name, this.values});
}
