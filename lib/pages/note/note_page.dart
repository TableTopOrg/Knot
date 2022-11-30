import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knot/constants.dart';
import 'package:knot/notes/notes.dart';
import 'package:knot/pages/audio_record/audio_record.dart';
import 'package:knot/pages/note/components/note_page_body.dart';
import 'package:knot/pages/speech_to_text/audio_to_text.dart';
import 'package:knot/pages/speech_to_text/realtime_speech_to_text.dart';
import '../audio_record/audio_play.dart';

class FloatingNote extends StatefulWidget {
  const FloatingNote({super.key, required this.note});

  final Note note;

  @override
  State<FloatingNote> createState() => _FloatingNoteState();
}

class _FloatingNoteState extends State<FloatingNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      drawer: AudioPlay(note: widget.note),
      body: Stack(
          children: [const NotePageBody(), AudioRecord(note: widget.note)]),
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
    // 아이콘 버튼 실행

    Navigator.push(
        context,
    MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')),
          );
        },
    color: Colors.grey,
    ),
          IconButton(
            icon: Icon(Icons.headset_mic), 
            onPressed: () {
              // 아이콘 버튼 실행
            
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
