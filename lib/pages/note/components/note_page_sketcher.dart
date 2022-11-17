import 'package:flutter/material.dart';

class Line {
  Line(this.path, this.color, this.width);

  List<Offset> path;
  Color color;
  double width;
}

class LiveLine {
  LiveLine(this.startTime);

  Line line = Line(<Offset>[], Colors.black, 5.0);
  DateTime? startTime, endTime;
}

class Sketcher extends CustomPainter {
  final List<Line> lines;

  Sketcher({required this.lines});

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
