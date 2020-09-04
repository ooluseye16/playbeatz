import 'package:flutter/material.dart';
import 'package:playbeatz/components/customBottomNavBarItem.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/screens/albums.dart';
import 'package:playbeatz/screens/allSongs.dart';
import 'package:provider/provider.dart';

import 'artists.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  Color color = Color.fromRGBO(28, 28, 28, 0.8); //rgba(28, 28, 28, 0.8);
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  getSongs() async {
    await Provider.of<SongProvider>(context, listen: false).getAllSongs();
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    List songs = Provider.of<SongProvider>(context).allSongs;
    List<Widget> _widgetOptions = <Widget>[
      Text(
        'Index 0: Home',
        style: optionStyle,
      ),
      MusicApp(),
      Albums(
        songList: songs,
      ),
      Artists(
        songList: songs,
      ),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: buildContainer(context),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Theme.of(context).splashColor,
          offset: Offset(-1, 0),
          blurRadius: 2,
        ),
      ]),
      height: 70.0,
      padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomNavBarItem(
            label: "Home",
            color: selectedIndex != 0 ? Colors.grey : color,
            icon: Icons.home,
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          CustomNavBarItem(
            label: "Songs",
            color: selectedIndex != 1 ? Colors.grey : color,
            icon: Icons.save_alt,
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          ),
          CustomNavBarItem(
            label: "Albums",
            color: selectedIndex != 2 ? Colors.grey : color,
            icon: Icons.filter,
            onPressed: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          CustomNavBarItem(
            label: "Artists",
            color: selectedIndex != 3 ? Colors.grey : color,
            icon: Icons.account_circle,
            onPressed: () {
              setState(() {
                selectedIndex = 3;
              });
            },
          ),
        ],
      ),
    );
  }
}
