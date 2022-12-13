import 'dart:io';

import 'package:flutter/material.dart';
import 'package:knot/pages/audio_record/audio_record.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../notes/notes.dart';

class AudioPlay extends StatefulWidget {
  const AudioPlay(
      {super.key,
      required this.note,
      required this.refresh,
      required this.progress});

  final Note note;
  final ValueChanged<int> refresh;
  final double progress;

  @override
  State<AudioPlay> createState() => _AudioPlayState();
}

class _AudioPlayState extends State<AudioPlay> {
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    widget.note.player.closePlayer();
  }

  Future initPlayer() async {
    // Player open
    await widget.note.player.openPlayer().then((value) => setState(() {
          widget.note.isPlayerInited = true;
        }));
  }

  /* path: 'n.aac' 파일 실행 */
  void startPlay(String path) async {
    assert(widget.note.isPlayerInited &&
        widget.note.isPlaybackReady &&
        widget.note.recorder.isStopped &&
        widget.note.player.isStopped);

    // Playing
    final directory = (await getApplicationDocumentsDirectory()).path;
    if (File("$directory/$path").existsSync()) {
      widget.note.isPlaybackReady = false;
      widget.note.player.startPlayer(
        fromURI: "$directory/$path",
        whenFinished: () => setState(() {
          widget.note.isPlaybackReady = true;
        }),
      );
    }
  }

  void stopPlay() {
    widget.note.player.stopPlayer().then((value) => setState(() {
          widget.note.isPlaybackReady = true;
        }));
  }

  void getPlayback(String path, int index) {
    if (!widget.note.isPlayerInited ||
        !widget.note.isPlaybackReady ||
        !widget.note.recorder.isStopped) {
      return;
    }
    widget.note.player.isStopped ? startPlay(path) : stopPlay();
    widget.refresh(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildAudioBar(),
        Positioned.fill(
            child: Align(
                alignment: Alignment.centerLeft,
                child: AudioRecord(
                  note: widget.note,
                  refresh: widget.refresh,
                )))
      ],
    );
  }

  ClipRRect buildAudioBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
          height: 40,
          width: 300,
          color: Colors.grey[300],
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.grey[400],
                width: 300 * widget.progress,
              ),
              GestureDetector(
                  child: ListWheelScrollView(
                    itemExtent: 22,
                    controller: fixedExtentScrollController,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) => selectedIndex = index,
                    children: widget.note.endTime
                        .asMap()
                        .entries
                        .map(
                          (e) =>
                              // buildRow(e)
                              buildTextBox(e),
                        )
                        .toList(),
                  ),
                  onTap: () => getPlayback(
                        '${widget.note.title}_$selectedIndex.aac',
                        selectedIndex,
                      ))
            ],
          )),
    );
  }

  Align buildTextBox(MapEntry<int, DateTime> e) {
    return Align(
        alignment: Alignment.center,
        child: Text(
          "${DateFormat('yyyy/MM/dd  kk:mm').format(widget.note.startTime[e.key])}-${DateFormat('kk:mm').format(widget.note.endTime[e.key])}",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.grey[800]),
        ));
  }

  Row buildRow(MapEntry<int, DateTime> e) {
    return Row(
      children: <Widget>[
        SizedBox(
          height: 40,
          width: 200,
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${DateFormat('yyyy-MM-dd – kk:mm').format(widget.note.startTime[e.key])} - ${DateFormat('kk:mm').format(widget.note.endTime[e.key])}",
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              )),
        ),
        // buildButton(e.key),
      ],
    );
  }

  SizedBox buildButton(int index) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () =>
              getPlayback('${widget.note.title}_$index.aac', index),
          icon: Icon(
              !widget.note.isPlaybackReady ? Icons.stop : Icons.play_arrow),
          color: !widget.note.isPlaybackReady ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
