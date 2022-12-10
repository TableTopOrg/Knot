import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class Note {
  /*final */late String title, thumbnail;
  /*final */late int time;

  late FlutterSoundPlayer player = FlutterSoundPlayer();
  late FlutterSoundRecorder recorder = FlutterSoundRecorder();
  late bool isPlayerInited;
  late bool isRecorderInited;
  late bool isPlaybackReady;
  List<DateTime> startTime = []; // 녹음 시작 시간
  List<DateTime> endTime = []; // 녹음 종료 시간
  late int cnt; // 녹음 파일 번호

  /* Json에서 class 변환할 때 DateTime 배열로 변환 어려워 임시로 사용 */
  List<String> tmp1 = [];
  List<String> tmp2 = [];

  Note({
    required this.title,
    required this.thumbnail,
    required this.time,
    this.isPlayerInited = false,
    this.isRecorderInited = false,
    this.isPlaybackReady = false,
    this.cnt = 0,
  });

  Note.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      tmp1 = List<String>.from(json['startTime']),
      tmp2 = List<String>.from(json['endTime']),
      cnt = json['cnt'];
      /* DateTime으로 변환시 오류
      startTime = List<DateTime>.from(Datetime.parse(json['startTime'].toString()),
      endTime = List<DateTime>.from(json['endTime']);
      */

  Map<String, dynamic> toJson() {
    /* DateTime -> String */
    List<dynamic> startTime = this.startTime.map((i) => i.toString()).toList();
    List<dynamic> endTime = this.endTime.map((i) => i.toString()).toList();
    return {
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'cnt': cnt,
    };
  }
}

List<Note> notes = [
  /*
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
   */
];
