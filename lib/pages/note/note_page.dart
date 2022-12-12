import 'dart:async';
import 'dart:convert';
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
import '../speech_to_text/speech_to_text_half.dart';

class FloatingNote extends StatefulWidget {
  const FloatingNote({super.key, required this.note, required this.notes});

  final Note note;
  final List<Note> notes;

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

  List<String> sharedWords = <String>[];

  @override
  void initState() {
    int index = 0, foundIndex = 0;
    widget.notes.forEach((element) {
      if (element.title == widget.note.title) foundIndex = index;
      index++;
    });
    sharedWords = widget.notes[foundIndex].sttStrings;
    super.initState();
  }

  void refresh(int index) {
    setState(() {
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

  @override
  void dispose() {
    int index = 0, foundIndex = 0;
    widget.notes.forEach((element) {
      if (element.title == widget.note.title) foundIndex = index;
      index++;
    });
    widget.notes[foundIndex].sttStrings = sharedWords;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(children: [
        Screenshot(
            controller: screenshotController,
            child: NotePageBody(
                note: widget.note,
                timestamp: timestamp,
                screenshotController: screenshotController,
                sharedString: sharedWords)),
        Align(
            alignment: Alignment.topCenter,
            child: AudioPlay(
                note: widget.note, refresh: refresh, progress: progress)),
        Align(
            alignment: Alignment.bottomCenter,
            child: SpeechToTextHalf(
              note: widget.note,
              sharedString: sharedWords,
              refresh: refresh,
            ))
      ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              sharedWords.add("시연을 위한 예시 문장입니다.");
            });
          },
          icon: const Icon(Icons.add),
          color: textColorLight,
        ),
      ],
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
    );
  }
}
