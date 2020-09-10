import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:playbeatz/constants.dart';
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
    return Container(
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
                        style: textStyle.copyWith(fontSize: 15.0),
                      ),

                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50.0,
                                child: TextField(
                                  controller: inputField,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Enter playlist name",
                                    hintStyle: textStyle.copyWith(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal
                                    ),
                                    fillColor: Color(0xffD5D5D5).withOpacity(
                                        0.25),
                                    filled: true,
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
                                    // labelText: 'Name',
                                    // labelStyle: textStyle,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
