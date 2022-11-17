import 'package:flutter/material.dart';
import '../../notes/notes.dart';

class AudioPlay extends StatefulWidget {
  const AudioPlay({super.key, required this.note});

  final Note note;

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

  Future initPlayer() async{
    // Player open
    await widget.note.player.openPlayer().then((value) => setState(() {
      widget.note.isPlayerInited = true;
    }));
  }

  /* path: 'n.aac' 파일 실행 */
  void startPlay(String path) {
    assert(widget.note.isPlayerInited && widget.note.isPlaybackReady && widget.note.recorder.isStopped && widget.note.player.isStopped);
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
    widget.note.player.stopPlayer().then((value) => setState((){
      widget.note.isPlaybackReady = true;
    }));
  }

  void getPlayback(String path){
    if(!widget.note.isPlayerInited || !widget.note.isPlaybackReady || !widget.note.recorder.isStopped){
      return;
    }
    widget.note.player.isStopped ? startPlay(path) : stopPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          itemCount: widget.note.cnt,
          itemBuilder: (BuildContext context, int index) {
            return  IconButton(
              onPressed: () => getPlayback('{${widget.note.title.replaceAll(' ', '')}_$index.aac'),
              icon: Icon(!widget.note.isPlaybackReady ? Icons.stop : Icons.play_arrow),
              color: !widget.note.isPlaybackReady ? Colors.grey : Colors.blue,
            );
          }
      ),
    );
  }
}
