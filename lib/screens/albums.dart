import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/constants.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/screens/playlist.dart';
import 'package:provider/provider.dart';

class Albums extends StatelessWidget {

 final List<Album> albumList = [];
  final ScrollController _controller = ScrollController();


  @override
  Widget build(BuildContext context) {
    var data = Provider.of<SongProvider>(context).allSongs;
    var newMap = groupBy(data, (obj) => obj['album']);
    newMap.forEach((key, value) => albumList.add(Album(
      title: key,
      values: value,
    )));
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
                                  playlistName: albumList[index].title,
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
