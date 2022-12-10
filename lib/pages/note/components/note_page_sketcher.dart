import 'dart:convert';

import 'package:flutter/material.dart';

class Line {
  Line(this.path, this.color, this.width);

  List<Offset> path = <Offset>[];
  Color color = Colors.redAccent;
  double width = 5.0;

  Line.fromString(String jsonString) {
    List<dynamic> readJson = jsonDecode(jsonString);
    path = <Offset>[];
    readJson.forEach((e) {
      path.add(Offset(e[0], e[1]));
    });
    color = Colors.redAccent;
    width = 5.0;
  }

  String offsetToJson() {
    final offsetString = path.map((e) => [e.dx, e.dy]).toList();
    return json.encode(offsetString);
  }
}

class LiveLine {
  LiveLine(this.startTime);

  Line line = Line(<Offset>[], Colors.black, 5.0);
  DateTime? startTime, endTime;
  double? scrollPosition;

  LiveLine.fromJson(Map json) {
    line = Line.fromString(json["line"]);
    startTime = DateTime.fromMillisecondsSinceEpoch(json["startTime"]);
    endTime = DateTime.fromMillisecondsSinceEpoch(json["endTime"]);
    scrollPosition = json["scrollPosition"];
  }

  Map toJson() {
    return {
      "line": line.offsetToJson(),
      "startTime": startTime?.millisecondsSinceEpoch,
      "endTime": endTime?.millisecondsSinceEpoch,
      "scrollPosition": scrollPosition
    };
  }
}

class Sketcher extends CustomPainter {
  final List<Line> lines;
  final Listenable repaint;

  Sketcher({required this.lines, required this.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.redAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < lines.length; ++i) {
      for (int j = 0; j < lines[i].path.length - 1; ++j) {
        paint.strokeWidth = lines[i].width;
        canvas.drawLine(lines[i].path[j], lines[i].path[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
