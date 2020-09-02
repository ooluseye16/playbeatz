import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongController extends ChangeNotifier{


  AudioPlayer audioPlayer;

  Future<void> play() async {
    audioPlayer.play();
  }

  Future<void> pause() async {
    audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }
}