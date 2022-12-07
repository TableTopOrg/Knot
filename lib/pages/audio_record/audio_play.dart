import 'package:flutter/material.dart';
import 'package:knot/pages/audio_record/audio_record.dart';
import '../../notes/notes.dart';

class AudioPlay extends StatefulWidget {
  const AudioPlay({super.key, required this.note, required this.refresh});

  final Note note;
  final VoidCallback refresh;

  @override
  State<AudioPlay> createState() => _AudioPlayState();
}

class _AudioPlayState extends State<AudioPlay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
  void startPlay(String path) {
    assert(widget.note.isPlayerInited &&
        widget.note.isPlaybackReady &&
        widget.note.recorder.isStopped &&
        widget.note.player.isStopped);
    widget.note.isPlaybackReady = false;

    // Playing
    widget.note.player.startPlayer(
      fromURI: path,
      whenFinished: () => setState(() {
        widget.note.isPlaybackReady = true;
      }),
    );
  }

  void stopPlay() {
    widget.note.player.stopPlayer().then((value) => setState(() {
          widget.note.isPlaybackReady = true;
        }));
  }

  void getPlayback(String path) {
    if (!widget.note.isPlayerInited ||
        !widget.note.isPlaybackReady ||
        !widget.note.recorder.isStopped) {
      return;
    }
    widget.note.player.isStopped ? startPlay(path) : stopPlay();
    widget.refresh();
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
        child: ListView.builder(
            itemCount: widget.note.cnt,
            itemBuilder: (BuildContext context, int index) {
              return IconButton(
                onPressed: () => getPlayback('${widget.note.title}_$index.aac'),
                icon: Icon(!widget.note.isPlaybackReady
                    ? Icons.stop
                    : Icons.play_arrow),
                color: !widget.note.isPlaybackReady ? Colors.grey : Colors.blue,
              );
            }),
      ),
    );
  }
}
