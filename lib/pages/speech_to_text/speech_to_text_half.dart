import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knot/notes/notes.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextHalf extends StatefulWidget {
  const SpeechToTextHalf(
      {super.key,
      required this.sharedString,
      required this.refresh,
      required this.note});

  final Note note;
  final List<String> sharedString;
  final ValueChanged<int> refresh;

  @override
  State<SpeechToTextHalf> createState() => _SpeechToTextHalfState();
}

class _SpeechToTextHalfState extends State<SpeechToTextHalf> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool initButton = false;
  String _lastWords = '';

  List<String> lastWords = <String>[];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    _initSpeech();
  }

  @override
  void dispose() {
    _timer.cancel();
    if (_speechToText.isListening) _speechToText.stop();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_speechToText.isNotListening) {
          if (_lastWords != "") {
            widget.sharedString.add(_lastWords);
            lastWords.add(_lastWords);
            widget.note.sttStrings = widget.sharedString;
            widget.refresh(-1);
          }
          _lastWords = "";
          _startListening();
        }
      },
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
          //localeId: "ko_KR",
          onResult: _onSpeechResult,
          listenFor: const Duration(seconds: 60),
          partialResults: true,
          cancelOnError: true,
          onDevice: true,
          listenMode: ListenMode.confirmation);
    }

    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.grey[200],
              width: 600,
              height: 40,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _lastWords == ""
                      ? "Recognizing English(for test)..."
                      : _lastWords,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ),
      ),
      // child: buildSTTlist(),
    );
  }

  ListView buildSTTlist() {
    return ListView(reverse: true, children: <Widget>[
      ...lastWords
          .map((e) => Text(
                e,
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ))
          .toList(),
      Text(
        _lastWords == "" ? "Recognizing English(for test)..." : _lastWords,
        style: TextStyle(
            color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ]);
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Text(
  //     _speechToText.isListening
  //         ? '$_lastWords'
  //         : _speechEnabled
  //             ? 'Tap the microphone to start listening...'
  //             : 'Speech not available',
  //   );
  // }
}
