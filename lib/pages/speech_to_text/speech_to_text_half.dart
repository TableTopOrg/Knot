import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextHalf extends StatefulWidget {
  const SpeechToTextHalf({super.key});

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
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_speechToText.isNotListening) {
          if (_lastWords != "") lastWords.add(_lastWords);
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
    await _speechToText.listen(
        //localeId: "ko_KR",
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 60),
        partialResults: true,
        cancelOnError: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);

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
      child: ListView(reverse: true, children: <Widget>[
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
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ]),
    );
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
