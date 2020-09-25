import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/screens/playlist.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class Genres extends StatelessWidget {

 final List<Genre> genreList = [];
  final ScrollController _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    var data =Provider.of<SongProvider>(context).allSongs;
    var newMap = groupBy(data, (obj) => obj['genre']);
    newMap.forEach((key, value) => genreList.add(Genre(
      name: key,
      values: value,
    )));
    genreList.sort((a, b) => a.name.compareTo(b.name));
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:Text("Genres"),

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
                                  playlistName: genreList[index].name,
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
