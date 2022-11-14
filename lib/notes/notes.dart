import 'package:flutter/material.dart';

class Note {
  final String title, thumbnail;
  final int time;
  Note({
    required this.title,
    required this.thumbnail,
    required this.time,
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
