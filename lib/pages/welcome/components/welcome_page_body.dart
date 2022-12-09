import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:knot/notes/notes.dart';
import 'package:knot/constants.dart';
import 'package:knot/pages/note/note_page.dart';
import 'package:path_provider/path_provider.dart';

class WelcomPageBody extends StatefulWidget {
  const WelcomPageBody({super.key});

  @override
  State<WelcomPageBody> createState() => _WelcomPageBodyState();
}

class _WelcomPageBodyState extends State<WelcomPageBody> {
  int refreshTokenMain = 0;

  double noteWidthFactor = 0.4;
  late Future<Directory> documentPath;

  void refreshMain() {
    setState(() {
      refreshTokenMain++;
    });
  }

  @override
  void initState() {
    documentPath = getApplicationDocumentsDirectory();
    loadNoteList(); // 앱 실행시 Note 불러오기
    super.initState();
  }

  /* Note 불러오는 함수 */
  void loadNoteList() async {
    final directory = await getApplicationDocumentsDirectory();
    for (int i = 0; ; i++) {
      if (!File('${directory.path}/note_$i.json').existsSync()) {
        return;
      }

      if(i == 0) {
        notes.clear();
      }

      String readJson = await File('${directory.path}/note_$i.json').readAsString();
      dynamic json = jsonDecode(readJson);
      Note n = Note.fromJson(json);
      n.startTime.clear();
      n.endTime.clear();
      for (int i = 0; i < n.tmp1.length; i++) {
        n.startTime.add(DateTime.parse(n.tmp1[i]));
        n.endTime.add(DateTime.parse(n.tmp2[i]));
      }
      n.tmp1.clear();
      n.tmp2.clear();
      n.isPlaybackReady = true;
      n.isPlayerInited = true;
      setState(() {
        notes.add(n);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColorLight,
      child: GridView.count(
          primary: false,
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          children: notes.map(((note) {
            return Column(children: [
              Expanded(
                child: buildThumbnail(note),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(note.title),
              )
            ]);
          })).toList()),
    );
  }

  StreamBuilder<Directory> buildThumbnail(Note note) {
    return StreamBuilder<Directory>(
        stream: Stream.fromFuture(documentPath),
        builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.hasData && snapshot.data != null) {
            if (File("${snapshot.data!.path}/${note.title}.png").existsSync()) {
              return AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FloatingNote(note: note)))
                        .then((value) => {imageCache.clear()}),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File("${snapshot.data!.path}/${note.title}.png"),
                          key: UniqueKey(),
                          fit: BoxFit.fitWidth,
                        )),
                  ),
                ),
              );
            }
          }
          return AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FloatingNote(note: note)))
                    .then((value) => refreshMain()),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset("assets/images/image_1.png")),
              ),
            ),
          );
        });
  }
}
