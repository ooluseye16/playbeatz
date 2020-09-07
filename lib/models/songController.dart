import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongController extends ChangeNotifier {
  SongController() {
    init();
  }

  AudioPlayer player;
  Duration duration;
  int currentTime = 0;
  String timeLeft = '';
  String timePlayed = '';
  String
  playlistName; // this is assigned from library depending on the playlist that is opened
  List
  allSongs; // this is assigned from library depending on the playlist that is opened
  static bool isFavourite = false;
  bool isShuffled = false;
  bool isRepeat = false;
  int currentSong;
  Map nowPlaying = {};
  bool isPlaying = false;
  int songLength = 0;
  List shuffledSongs;


  void shuffle() {
    allSongs.shuffle();
    shuffledSongs = allSongs;
  }

  void init() {
    SharedPreferences.getInstance().then((pref) {
      isShuffled = pref.getBool('shuffle') ?? false;
      isRepeat = pref.getBool('repeat') ?? false;
    });
    notifyListeners();
  }

  void settings({bool repeat = false, bool shuffle = false}) {
    isShuffled = shuffle;
    isRepeat = repeat;
    notifyListeners();
  }

  void setIsPlaying(bool val) {
    isPlaying = val;
    notifyListeners();
  }

  Future<void> setUp(dynamic song) async {
    nowPlaying = song;
    // isFavourite = await playListDB.isFavourite(nowPlaying);
    // playListDB.saveNowPlaying(nowPlaying);
    currentSong =
        allSongs.indexWhere((element) => element['path'] == nowPlaying['path']);
    player = AudioPlayer();
    duration = await player.setFilePath(nowPlaying['path']);
    songLength = duration.inSeconds;
    timeLeft = '${duration.inMinutes}:${duration.inSeconds % 60}';
    getPosition();
    play();
  }

  void getPosition() {
    player.getPositionStream().listen(
      (event) {
        currentTime = event.inSeconds;
        timePlayed = '${event.inMinutes}:${event.inSeconds % 60}';
        if (currentTime >= songLength) {
          skip(next: true);
        }
        notifyListeners();
      },
    ).onError((error) => print('hmmmmm: $error'));
  }

  Future<void> play() async {
    setIsPlaying(true);
    player.play();
  }

  Future<void> pause() async {
    setIsPlaying(false);
    player.pause();
  }

  Future<void> seek({bool forward = false, bool rewind = false}) async {
    if (forward) {
      await player.seek(Duration(seconds: currentTime + 10));
    } else {
      await player.seek(Duration(seconds: currentTime - 10));
    }
  }


  Future<void> skip(
      {bool next = false, bool prev = false, BuildContext context}) async {
    currentSong =
        allSongs.indexWhere((element) => element['path'] == nowPlaying['path']);
    //List shuffled = [...allSongs];
    await disposePlayer();
    try {
      if (isRepeat) {
        nowPlaying = nowPlaying;
      } else if (isShuffled) {
        //shuffled.shuffle();
        currentSong = shuffledSongs
            .indexWhere((element) => element['path'] == nowPlaying['path']);
        nowPlaying = next
            ? shuffledSongs[currentSong += 1]
            : shuffledSongs[currentSong -= 1];
      } else {
        nowPlaying =
            next ? allSongs[currentSong += 1] : allSongs[currentSong -= 1];
      }
    } on RangeError catch (e) {
      nowPlaying = allSongs.first;
      debugPrint(e.toString());
    } finally {
      await setUp(nowPlaying);
      notifyListeners();
    }
  }

  Future<void> playlistControlOptions(dynamic playlistNowPlaying) async {
    // if nothing is currently playing
    if (nowPlaying['path'] == null) {
      await setUp(playlistNowPlaying);
      setIsPlaying(true);
      // if the song currently playing is taped on
    } else if (nowPlaying['path'] == playlistNowPlaying['path']) {
      isPlaying ? pause() : play();
      // if a different song is selected
    } else if (nowPlaying['path'] != playlistNowPlaying['path']) {
      disposePlayer();
      await setUp(playlistNowPlaying);
      setIsPlaying(true);
    }
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> disposePlayer() async {
    if (player.playbackState == AudioPlaybackState.playing ||
        player.playbackState == AudioPlaybackState.paused) {
      await player.dispose();
    }
    setIsPlaying(false);
    currentTime = 0;
    timeLeft = '';
    timePlayed = '';
    notifyListeners();
  }
}
