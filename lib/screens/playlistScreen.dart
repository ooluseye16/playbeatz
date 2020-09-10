import 'package:flutter/material.dart';
import 'package:playbeatz/models/playlistDB.dart';
import 'package:playbeatz/screens/playlist.dart';
import 'package:provider/provider.dart';

class PlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlayListDB>(
        builder: (_, database, child) {
          return ListView.builder(
              itemCount: database.playList.length,
              itemBuilder: (context, index) {
                List songs = database.playList[index]['songs'];
                return database.playList.isNotEmpty
                    ? ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Playlist(
                                  songList: songs,
                                  playlistName: database.playList[index]
                                      ['name'],
                                ),
                              ));
                        },
                        leading: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: songs[0]['artwork'] != null
                              ? MemoryImage(
                                  songs[0]['artwork'],
                                )
                              : null,
                          child: songs[0]['artwork'] != null
                              ? null
                              : Text(songs[0]['title'][0]),
                        ),
                        title: Text(database.playList[index]['name']),
                        subtitle: songs.length == null
                            ? Text("Empty playlist")
                            : Text("${songs.length} songs"),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                          ),
                          onPressed: () {},
                        ),
                      )
                    : Center(
                        child: Text("No Playlist"),
                      );
              });
        },
      ),
    );
  }
}
