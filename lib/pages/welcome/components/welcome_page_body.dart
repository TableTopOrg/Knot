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
  double noteWidthFactor = 0.4;
  late Future<Directory> documentPath;

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
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: notes.map(((note) {
            return buildThumbnail(note);
          })).toList()),
    );
  }

  FutureBuilder<Directory> buildThumbnail(Note note) {
    return FutureBuilder<Directory>(
        future: documentPath,
        builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (File("${snapshot.data!.path}/${note.title}.png").existsSync()) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FloatingNote(note: note))),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                        File("${snapshot.data!.path}/${note.title}.png"))),
              );
            }
          }
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FloatingNote(note: note))),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(note.thumbnail)),
          );
        });
  }
}
