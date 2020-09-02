import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class SongProvider extends ChangeNotifier {

  List allSongs =[];
  List recentlyAdded = [];

  void recentActivity() {
    List newList = allSongs;
    newList.sort((a, b) => a['recentlyAdded'].compareTo(b['recentlyAdded']));
    recentlyAdded.addAll(newList.reversed);
    allSongs.sort((a, b) => a['title'].compareTo(b['title']));
    notifyListeners();
  }

  Future<void> getAllSongs() async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted && Platform.isAndroid) {
      List<Directory> deviceStorage = await getExternalStorageDirectories();
      List<Directory> pathToStorage = [];
      for(var direction in deviceStorage) {
        pathToStorage.add(Directory(direction.path.split("Android")[0]));
      }
      List<FileSystemEntity> allFolders = await getAllFolders(pathToStorage);
      for (FileSystemEntity folder in allFolders){
        if(FileSystemEntity.isFileSync(folder.path) && basename(folder.path).endsWith('mp3')) {
          allSongs.add(await songInfo(folder.path));
          notifyListeners();
        } else if (FileSystemEntity.isDirectorySync(folder.path)) {
          await getAllFiles(folder.path);
        }
      }
      recentActivity();
    } else {
      permissionStatus = await Permission.storage.request();
    }
    notifyListeners();
  }
  Future<List<FileSystemEntity>> getAllFolders(List paths) async {
    List<FileSystemEntity> allFolders = [];
    for (var dir in paths) {
      allFolders.addAll([...dir.listSync()]);
    }
    return allFolders;
  }

  Future<void> getAllFiles(String path) async {
    for (FileSystemEntity file in Directory(path).listSync()) {
      if (FileSystemEntity.isFileSync(file.path) && basename(file.path).endsWith('mp3')) {
        allSongs.add(await songInfo(file.path));
        notifyListeners();
      } else if (FileSystemEntity.isDirectorySync(file.path) && !basename(file.path).startsWith('.') && !file.path.contains('/Android')) {
        getAllFiles(file.path);
      } else {}
    }
  }

  Future<Map<String, dynamic>> songInfo(String file) async {
    var audioTagger = Audiotagger();
    var info;
    var fileInfo;
    var date;
  //  Image artwork;
    try {
      info = await audioTagger.readTagsAsMap(path: file,);
      fileInfo = File(file);
      date = fileInfo.lastAccessedSync();
     // artwork = audioTagger.readArtwork(path: file) as Image;
    } catch (e) {
      debugPrint(e.toString());
    }
    return{
      'path': file,
      'title': info != null && info['title'] != '' ? info['title'] : file.split('/').last.split('.mp3').first,
      'artist' : info != null && info['artist'] != '' ? info['artist'] : 'Unknown artist',
      'recentlyAdded' : date ?? 00-00-00,
    //  'artwork' : artwork ?? null,
    };
  }
}

