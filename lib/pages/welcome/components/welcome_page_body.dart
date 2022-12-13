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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColorLight,
      child: GridView.count(
          primary: false,
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          crossAxisCount: (MediaQuery.of(context).size.width / 200).round(),
          mainAxisSpacing: 10,
          children: notes.map(((note) {
            return Column(children: [
              Expanded(
                child: buildThumbnail(note, notes),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(note.title),
              )
            ]);
          })).toList()),
    );
  }

  StreamBuilder<Directory> buildThumbnail(Note note, List<Note> notes) {
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
                                builder: (context) =>
                                    FloatingNote(note: note, notes: notes)))
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
                        builder: (context) => FloatingNote(
                              note: note,
                              notes: notes,
                            ))).then((value) => refreshMain()),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset("assets/images/image_1.png")),
              ),
            ),
          );
        });
  }
}
