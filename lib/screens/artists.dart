import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/screens/playlist.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class Artists extends StatelessWidget {

  final List<Artist> artistList = [];
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<SongProvider>(context).allSongs;
    var newMap = groupBy(data, (obj) => obj['artist']);
    newMap.forEach((key, value) => artistList.add(Artist(
      name: key,
      values: value,
    )));
    artistList.sort((a, b) => a.name.compareTo(b.name));

    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Artists"),
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
              itemCount: artistList.length,
              itemBuilder: (context, index) {
                var data = artistList[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Playlist(
                                  songList: data.values,
                                  playlistName: data.name,
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

class Artist {
  final String name;
  final List values;

  Artist({this.name, this.values});
}
