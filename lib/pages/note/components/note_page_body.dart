import 'package:flutter/material.dart';
import 'package:knot/pages/note/components/note_page_sketcher.dart';

class NotePageBody extends StatefulWidget {
  const NotePageBody({super.key, required this.timestamp});

  final int timestamp;

  @override
  State<NotePageBody> createState() => _NotePageBodyState();
}

class _NotePageBodyState extends State<NotePageBody> {
  List<LiveLine> liveLines = <LiveLine>[];
  LiveLine liveLine = LiveLine(DateTime.now());

  double currWidth = 5.0;
  Color currColor = Colors.black;
  DateTime timeBar = DateTime.now();

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
