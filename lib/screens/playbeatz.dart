import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:playbeatz/components/createPlaylist.dart';
import 'package:playbeatz/components/customBottomNavBarItem.dart';
import 'package:playbeatz/constants.dart';
import 'package:playbeatz/models/playlistDB.dart';
import 'package:playbeatz/models/provider.dart';
import 'package:playbeatz/models/songController.dart';
import 'package:playbeatz/screens/albums.dart';
import 'package:playbeatz/screens/allSongs.dart';
import 'package:playbeatz/screens/genres.dart';
import 'package:playbeatz/screens/homepage.dart';
import 'package:playbeatz/screens/playlist.dart';
import 'package:playbeatz/screens/playlistScreen.dart';
import 'package:provider/provider.dart';
import 'artists.dart';
import 'nowPlaying.dart';

class PlayBeatz extends StatefulWidget {
  @override
  _PlayBeatzState createState() => _PlayBeatzState();
}

class _PlayBeatzState extends State<PlayBeatz> {
  PlayListDB database = PlayListDB();
  SongProvider provider = SongProvider();
  int selectedIndex = 0;
  Color color = Color.fromRGBO(28, 28, 28, 0.8); //rgba(28, 28, 28, 0.8);
  var currentSong;

  void getCurrentAppTheme() async {
    provider.darkTheme = await provider.darkThemePreferences.getTheme();
  }

  getSongs() {
    Provider.of<SongProvider>(context, listen: false).init();
  }

  void lastSong() async {
    currentSong = await PlayListDB.lastPlayed(context);
    setState(() {});
  }

  @override
  void initState() {
    getCurrentAppTheme();
    lastSong();
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<SongProvider>(context);
    // List songs = Provider.of<SongProvider>(context).allSongs;
    List<String> titleOptions = <String>[
      "Home",
      "Songs",
      "Albums",
      "Playlists",
    ];
    List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      AllSongs(),
      Albums(),
      PlaylistScreen(),
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
          builder: (context) => IconButton(
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
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0)),
        child: Drawer(
          child: Column(
            children: [
              Consumer<SongController>(builder: (_, controller, child) {
                currentSong = controller.nowPlaying['path'] == null
                    ? currentSong
                    : controller.nowPlaying;
                return InkWell(
                  onTap: () async {
                    controller.allSongs = controller.allSongs == null
                        ? Provider.of<SongProvider>(context, listen: false)
                            .allSongs
                        : controller.allSongs;
                    controller.playlistName = controller.playlistName == null
                        ? 'All songs'
                        : controller.playlistName;
                    if (currentSong != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NowPlaying(
                            currentSong: currentSong,
                            songList: controller.allSongs,
                          ),
                        ),
                      );
                    }
                  },
                  child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(top: 25.0, left: 15.0),
                        leading: Container(
                          height: 60.0,
                          width: 60.0,
                          // child: currentSong['artwork'] != null
                          //     ? Image.memory(
                          //   currentSong['artwork'],
                          //   fit: BoxFit.fill,
                          // )
                          //     : null,
                          decoration: BoxDecoration(
                              image: currentSong != null && currentSong['artwork'] != null
                                  ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(
                                        currentSong['artwork'],
                                      ),
                                    )
                                  : null,
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0.08),
                                ),
                              ]),
                        ),
                        title: Text(
                          currentSong == null ? 'title' : currentSong['title'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          currentSong == null
                              ? 'artist'
                              : currentSong['artist'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                );
              }),
              DrawerTile(
                icon: Icons.favorite,
                title: "Favorite",
                navigateTo: Playlist(
                  songList: database.playList[0]['songs'],
                  playlistName: database.playList[0]['name'],
                ),
              ),
              DrawerTile(
                icon: Icons.person,
                title: "Artists",
                navigateTo: Artists(),
              ),
              DrawerTile(
                icon: Icons.music_note,
                title: "Genres",
                navigateTo: Genres(),
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
        ListTile(
          leading: Icon(
            Icons.lightbulb_outline,
            color: Color(0xff254bc8).withOpacity(0.7),
          ),
          title: Text(
            "Dark Mode",
            style: kDrawerTextStyle,
          ),
          trailing: Checkbox(
            value: themeChange.darkTheme,
            onChanged: (bool value) {
              themeChange.darkTheme = value;
            },
          ),
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
            svgImage: "images/home.svg",
            onPressed: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          CustomNavBarItem(
            label: "Songs",
            color: selectedIndex != 1 ? Colors.grey : color,
            svgImage: 'images/songs.svg',
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CreatePlayList(
                    height: 35,
                    width: 35,
                    isCreateNew: false,
                  );
                },
              );
            },
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    colors: [Colors.blue, Color(0xff254bc8).withOpacity(0.7)]),
              ),
              child: Center(
                  child: Icon(
                Icons.add,
                color: Colors.white,
                size: 25.0,
              )),
            ),
          ),
          CustomNavBarItem(
            label: "Albums",
            color: selectedIndex != 2 ? Colors.grey : color,
            onPressed: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          CustomNavBarItem(
            label: "Playlists",
            color: selectedIndex != 3 ? Colors.grey : color,
            svgImage: 'images/playlists.svg',
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

  const DrawerTile({Key key, this.icon, this.title, this.navigateTo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xff254bc8).withOpacity(0.7),
      ),
      title: Text(
        title,
        style: kDrawerTextStyle,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => navigateTo,
            ));
      },
    );
  }
}
