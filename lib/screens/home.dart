import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/components/customBottomNavBarItem.dart';
import 'package:playbeatz/constants.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/screens/albums.dart';
import 'package:playbeatz/screens/allSongs.dart';
import 'package:playbeatz/screens/genres.dart';
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
    List<String> titleOptions = <String>[
      "Home",
      "Songs",
      "Albums",
      "Playlists",
    ];
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
      appBar: GradientAppBar(
        title: Text(titleOptions.elementAt(selectedIndex)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
        gradient: gradient,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Image.asset(
                  "images/menu.png",
                  height: 15,
                  width: 34,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0)),
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(top: 25.0, left: 15.0),
                    leading: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),
                    ),
                    title: Text("Obisesan Oluseye"),
                    subtitle: Text("@oluseye_obitola"),
                  )
              ),
              DrawerTile(
                icon: Icons.favorite,
                title: "Favorite",
              ),
              DrawerTile(
                icon: Icons.person,
                title: "Artists",
                navigateTo: Artists(songList: songs,),
              ),
              DrawerTile(
                icon: Icons.music_note,
                title: "Genres",
                navigateTo: Genres(songList: songs,),
              ),
              DrawerTile(
                icon: Icons.timer,
                title: "Timer",
              ),
              DrawerTile(
                icon: Icons.history,
                title: "Recent History",
              ),
              DrawerTile(
                icon: Icons.settings,
                title: "Settings",
              ),
              DrawerTile(
                icon: Icons.lightbulb_outline,
                title: "Dark mode",
              ),
            ],
          ),
        ),
      ),
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
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    Colors.blue,
                    Color(0xff254bc8).withOpacity(0.7)
                  ]
              ),
            ),
            child: Center(
                child: Icon(Icons.add, color: Colors.white, size: 25.0,)),
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
            label: "Playlists",
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

class DrawerTile extends StatelessWidget {
  final IconData icon;

  final String title;
  final Widget navigateTo;

  const DrawerTile({
    Key key,
    this.icon,
    this.title,
    this.navigateTo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Color(0xff254bc8).withOpacity(0.7),),
      title: Text(title, style: kDrawerTextStyle,),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => navigateTo,
        ));
      },
    );
  }
}
