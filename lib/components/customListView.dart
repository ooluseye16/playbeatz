import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:provider/provider.dart';

class CustomListView extends StatefulWidget {
   final List songList;
   final double width;
   final String sortBy;
  CustomListView({this.songList, this.width, this.sortBy});
  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    var songs = widget.songList;
    return Container(
      height: 200.0,
      child: songs.isNotEmpty
          ? ListView.builder(
          itemCount: songs.length > 5 ? 5: songs.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Consumer<SongController>(
              builder: (_, controller, child) {
                if(widget.sortBy != null){
                  songs.sort((a, b) => b[widget.sortBy]
                      .compareTo(a[widget.sortBy]));
                }
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10.0)),
                    semanticContainer: true,
                    clipBehavior:
                    Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 200.0,
                      width: widget.width,
                      child: Stack(
                        children: [
                          songs[index]['artwork'] != null
                              ? Container(
                            height: 200.0,
                            width: 300.0,
                            child: Image.memory(
                              songs[index]
                              ['artwork'],
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox.shrink(),
                          Container(
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(songs[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:widget.width > 200? 15.0: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            );
          })
          : Center(child: CircularProgressIndicator()),
    );
  }
}
