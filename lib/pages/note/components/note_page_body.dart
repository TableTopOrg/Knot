import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:knot/pages/note/components/note_page_sketcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../notes/notes.dart';

class NotePageBody extends StatefulWidget {
  const NotePageBody(
      {super.key,
      required this.note,
      required this.timestamp,
      required this.screenshotController});

  final Note note;
  final int timestamp;
  final ScreenshotController screenshotController;

  @override
  State<NotePageBody> createState() => _NotePageBodyState();
}

class _NotePageBodyState extends State<NotePageBody> {
  List<LiveLine> liveLines = <LiveLine>[];
  LiveLine liveLine = LiveLine(DateTime.now());

  double currWidth = 5.0;
  Color currColor = Colors.black;
  DateTime timeBar = DateTime.now();

  @override
  void initState() {
    loadNote();
    super.initState();
  }

  void screenCapture() async {
    final image = await widget.screenshotController.capture();
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/${widget.note.title}.png').writeAsBytes(image);
  }

  void loadNote() async {
    final directory = await getApplicationDocumentsDirectory();
    if (!File('${directory.path}/${widget.note.title}.json').existsSync()) {
      return;
    }
    String readJson = await File('${directory.path}/${widget.note.title}.json')
        .readAsString();
    List<dynamic> readMap = jsonDecode(readJson);
    setState(() {
      readMap.forEach((e) {
        liveLines.add(LiveLine.fromJson(e));
      });
    });
  }

  void saveNote() async {
    final directory = await getApplicationDocumentsDirectory();
    final saveJson = jsonEncode([...liveLines, liveLine]);
    File('${directory.path}/${widget.note.title}.json').writeAsString(saveJson);
  }

  void handleDragStart(DragStartDetails dragStartDetails) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(dragStartDetails.globalPosition);

    setState(() {
      liveLine = LiveLine(DateTime.now());
      liveLine.line = Line([point], currColor, currWidth);
    });
  }

  void handleDragEnd(DragEndDetails dragEndDetails) {
    setState(() {
      timeBar = liveLine.endTime = DateTime.now();
      liveLines.add(liveLine);
    });
    saveNote();
    screenCapture();
  }

  void handleDragUpdate(DragUpdateDetails dragUpdateDetails) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(dragUpdateDetails.globalPosition);

    final path = List<Offset>.from(liveLine.line.path)..add(point);
    setState(() {
      liveLine.line = Line(path, currColor, currWidth);
    });
  }

  List<Line> getLinesUsingTimestamp(int timestamp) {
    if (timestamp == 0) {
      return [...liveLines.map((e) => e.line), liveLine.line];
    } else {
      return [...liveLines, liveLine]
          .where((element) =>
              (element.endTime?.millisecondsSinceEpoch ?? widget.timestamp) <
              widget.timestamp)
          .map((e) => e.line)
          .toList();
    }
  }

  GestureDetector buildGestureDetector(BuildContext buildContext) {
    return GestureDetector(
        onPanStart: handleDragStart,
        onPanEnd: handleDragEnd,
        onPanUpdate: handleDragUpdate,
        child: RepaintBoundary(
            child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CustomPaint(
                    painter: Sketcher(
                  lines: getLinesUsingTimestamp(widget.timestamp),
                )))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [buildGestureDetector(context)],
      ),
    );
  }
}
