import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class Note {
  final String title, thumbnail;
  final int time;

  FlutterSoundPlayer player = FlutterSoundPlayer();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isPlayerInited;
  bool isRecorderInited;
  bool isPlaybackReady;
  var startTime = []; // 녹음 시작 시간
  var endTime = [];   // 녹음 종료 시간
  int cnt;         // 녹음 파일 번호

  Note({
    required this.title,
    required this.thumbnail,
    required this.time,

    this.isPlayerInited = false,
    this.isRecorderInited = false,
    this.isPlaybackReady = false,
    this.cnt = 0,
  });
}

List<Note> notes = [
  Note(
      title: "Parallel programing",
      thumbnail: "assets/images/image_1.png",
      time: 20221011),
  Note(
      title: "C programing",
      thumbnail: "assets/images/image_2.png",
      time: 20221211),
  Note(
      title: "Android programing",
      thumbnail: "assets/images/image_3.png",
      time: 20211011)
];
