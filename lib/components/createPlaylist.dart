import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playbeatz/models/playlistDB.dart';
import 'package:playbeatz/screens/addToPlaylist.dart';
import 'package:provider/provider.dart';

class CreatePlayList extends StatefulWidget {
  CreatePlayList({this.height, this.width, this.isCreateNew = true, this.song});

  final double width;
  final double height;
  final dynamic song; // for adding to playlist from pop up options
  final bool isCreateNew;

  @override
  _CreatePlayListState createState() => _CreatePlayListState();
}

class _CreatePlayListState extends State<CreatePlayList> {
  bool createNew;
  String playlistName;
  TextEditingController inputField = TextEditingController();

  @override
  void initState() {
    createNew = widget.isCreateNew;
    super.initState();
  }

  @override
  void deactivate() {
    playlistName = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size viewsSize = MediaQuery.of(context).size;
    TextStyle textStyle = TextStyle(
        fontSize: 15, fontWeight: FontWeight.w400, fontFamily: 'Acme');

    return Container(
      height: orientation == Orientation.portrait
          ? viewsSize.height
          : viewsSize.width,
      width: orientation == Orientation.portrait
          ? viewsSize.width
          : viewsSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            elevation: 6.0,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 300,
              width: 300,
              padding: EdgeInsets.all(20),
              child: Consumer<PlayListDB>(
                builder: (context, playlistDB, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New playlist',
                        style: textStyle,
                      ),
                      //     : Text(
                      //   'Add to playlist',
                      //   style: textStyle,
                      // ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: inputField,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: textStyle,
                                ),
                              ),
                            ]),
                      ),
                      //     : Expanded(
                      //   child: ListView.builder(
                      //     itemCount: playlistDB.playList.length,
                      //     itemBuilder: (context, index) {
                      //       return FlatButton(
                      //         onPressed: () async {
                      //           await playlistDB.addToPlaylist(
                      //               playlistDB.playList[index]['name'],
                      //               widget.song ??
                      //                   Provider.of<SongController>(
                      //                       context,
                      //                       listen: false)
                      //                       .nowPlaying);
                      //           Navigator.pop(context);
                      //         },
                      //         child: index > 0 &&
                      //             index < playlistDB.playList.length
                      //             ? Text(
                      //           playlistDB.playList[index]['name'],
                      //           style: textStyle,
                      //         )
                      //             : SizedBox.shrink(),
                      //       );
                      //     },
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: textStyle,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              if (inputField.text != '') {
                                playlistName = inputField.text;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddToPlaylist(
                                              playlistName: playlistName,
                                            )));
                                //Navigator.pop(context);
                              } else {
                                print('empty field');
                              }
                            },
                            child: Text(
                              'Create playlist',
                              style: textStyle,
                            ),
                          )
                          //     : FlatButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       createNew = true;
                          //     });
                          //     print(createNew);
                          //   },
                          //   child: Text(
                          //     'New playlist',
                          //     style: textStyle,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
