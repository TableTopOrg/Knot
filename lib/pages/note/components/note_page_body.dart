import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
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
      required this.screenshotController,
      required this.sharedString});

  final Note note;
  final int timestamp;
  final ScreenshotController screenshotController;
  final List<String> sharedString;

  @override
  State<NotePageBody> createState() => _NotePageBodyState();
}

class _NotePageBodyState extends State<NotePageBody> {
  List<LiveLine> liveLines = <LiveLine>[];
  LiveLine liveLine = LiveLine(DateTime.now());

  double currWidth = 5.0;
  Color currColor = Colors.black;
  DateTime timeBar = DateTime.now();

  ScrollController _customController = ScrollController();
  ValueNotifier<int> _counterRepaint = ValueNotifier<int>(0);

  String directory = "";

  @override
  void initState() {
    loadNote();
    _customController.addListener(() {
      setState(() {});
    });

    getApplicationDocumentsDirectory().then((value) {
      setState(() {
        directory = value.path;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void screenCapture() async {
    final image = await widget.screenshotController.capture();
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/${widget.note.title}.png').writeAsBytesSync(image);
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
    final point = box
        .globalToLocal(dragStartDetails.globalPosition)
        .translate(0, _customController.offset);

    setState(() {
      liveLine = LiveLine(DateTime.now());
      liveLine.line = Line([point], currColor, currWidth);
      liveLine.scrollPosition = _customController.offset;
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
    final point = box
        .globalToLocal(dragUpdateDetails.globalPosition)
        .translate(0, _customController.offset);

    final path = List<Offset>.from(liveLine.line.path)..add(point);
    setState(() {
      liveLine.line = Line(path, currColor, currWidth);
    });
  }

  List<Line> getLinesUsingTimestamp(int timestamp) {
    final filterdLines = timestamp == 0
        ? [...liveLines, liveLine]
        : [...liveLines, liveLine].where((element) =>
            (element.endTime?.millisecondsSinceEpoch ?? widget.timestamp) <
            widget.timestamp);

    return filterdLines.map((e) => e.line).toList();
  }

  Container buildGestureDetector(BuildContext buildContext) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
          onPanStart: handleDragStart,
          onPanEnd: handleDragEnd,
          onPanUpdate: handleDragUpdate,
          onDoubleTap: () {
            setState(() {
              if (liveLines.isNotEmpty) {
                liveLine = LiveLine(DateTime.now());
                liveLines.removeLast();
              }
            });
          },
          onLongPress: () {
            setState(() {
              if (widget.sharedString.isNotEmpty) {
                setState(() {
                  widget.sharedString.removeLast();
                  _customController.jumpTo(_customController.offset - 1);
                });
              }
            });
          },
          child: RepaintBoundary(
              child: Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      CustomPaint(
                          painter: Sketcher(
                              lines: getLinesUsingTimestamp(widget.timestamp),
                              repaint: _counterRepaint,
                              scrollPostion: _customController.hasClients
                                  ? _customController.offset
                                  : 0)),
                    ],
                  )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            controller: _customController,
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            children: widget.sharedString.map((e) {
              if ((e.substring(e.length - 4) == ".jpg" ||
                      e.substring(e.length - 4) == ".png") &&
                  directory != "" &&
                  File('$directory/$e').existsSync()) {
                return Container(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
                    child: Image.file(File('$directory/$e')));
              } else {
                return Container(
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
                    child: Text(
                      e,
                      style: TextStyle(fontSize: 20),
                    ));
              }
            }).toList(),
          ),
          buildGestureDetector(context),
        ],
      ),
    );
  }
}
