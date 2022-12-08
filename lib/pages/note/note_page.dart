import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:knot/constants.dart';
import 'package:knot/notes/notes.dart';
import 'package:knot/pages/audio_record/audio_record.dart';
import 'package:knot/pages/note/components/note_page_body.dart';
import 'package:knot/pages/speech_to_text/audio_to_text.dart';
import 'package:knot/pages/speech_to_text/realtime_speech_to_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../audio_record/audio_play.dart';

class FloatingNote extends StatefulWidget {
  const FloatingNote({super.key, required this.note});

  final Note note;

  @override
  State<FloatingNote> createState() => _FloatingNoteState();
}

class _FloatingNoteState extends State<FloatingNote> {
  int refreshToken = 0;
  int playIndex = 0;
  int playStartTime = 0;

  late Timer _timer;
  int timestamp = 0;
  double progress = 0;

  ScreenshotController screenshotController = ScreenshotController();

  void refresh(int index) {
    setState(() {
      screenCapture();
      refreshToken++;
      if (index != -1) {
        playIndex = index;
        timestamp = widget.note.startTime[index].millisecondsSinceEpoch;
        startTimer();
      }
    });
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 100);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timestamp >=
            widget.note.endTime[playIndex].millisecondsSinceEpoch) {
          setState(() {
            timer.cancel();
            timestamp = 0;
            progress = 0;
            screenCapture();
          });
        } else {
          setState(() {
            timestamp += 100;
            progress = (timestamp -
                    widget.note.startTime[playIndex].millisecondsSinceEpoch) /
                (widget.note.endTime[playIndex].millisecondsSinceEpoch -
                    widget.note.startTime[playIndex].millisecondsSinceEpoch);
          });
        }
      },
    );
  }

  void screenCapture() async {
    final image = await screenshotController.capture();
    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    File('${directory.path}/${widget.note.title}.png').writeAsBytes(image);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      // drawer: AudioPlay(note: widget.note),
      body: Stack(children: [
        Screenshot(
            child: NotePageBody(
              timestamp: timestamp,
            ),
            controller: screenshotController),
        Align(
            alignment: Alignment.topCenter,
            child: AudioPlay(
                note: widget.note, refresh: refresh, progress: progress))
      ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.note.title,
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: textColorLight, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/icons/back.svg")),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: 'Flutter Demo Home Page')),
            );
          },
          color: Colors.grey,
        ),
        IconButton(
          icon: Icon(Icons.headset_mic),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpeechSampleApp()),
            );
          },
          color: Colors.grey,
        )
      ],
    );
  }
}
