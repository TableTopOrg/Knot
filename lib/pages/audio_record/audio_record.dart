import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../notes/notes.dart';

class AudioRecord extends StatefulWidget {
  const AudioRecord(
      {super.key,
      required this.note,
      required this.refresh}); //{Key? key}) : super(key: key);

  final Note note;
  final ValueChanged<int> refresh;

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.note.recorder.closeRecorder();
  }

  Future initRecorder() async {
    // 마이크 허용권한 얻고 Recorder open
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('permission not granted');
    }
    await widget.note.recorder.openRecorder();
    widget.note.recorder
        .setSubscriptionDuration(const Duration(milliseconds: 500));
    widget.note.isRecorderInited = true;
  }

  void startRecord() {
    // 녹음 시 title_cnt.aac 파일 형태로 저장하고, cnt 증가시킴
    String path = '${widget.note.title}_${widget.note.cnt}.aac';
    widget.note.recorder
        .startRecorder(
          toFile: path,
        )
        .then((value) => setState(() {
              //    print(path);
              widget.note.startTime.add(DateTime.now());
              widget.note.cnt++;
            }));
  }

  void stopRecord() {
    widget.note.recorder.stopRecorder().then((value) => setState(() {
          widget.note.isPlaybackReady = true;
          widget.note.endTime.add(DateTime.now());
          widget.refresh(-1);
        }));
  }

  void getRecorder() {
    if (!widget.note.isRecorderInited || !widget.note.player.isStopped) {
      return;
    }
    widget.note.recorder.isStopped ? startRecord() : stopRecord();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: getRecorder,
      icon: Icon(widget.note.recorder.isRecording ? Icons.stop : Icons.circle),
      color: widget.note.recorder.isRecording ? Colors.grey : Colors.red,
    );
  }
}
