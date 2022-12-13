import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knot/constants.dart';
import 'package:knot/firebase_options.dart';
import 'package:knot/notes/notes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:knot/pages/welcome/components/welcome_page_body.dart';
import 'package:knot/upload_Json.dart';
import 'package:path_provider/path_provider.dart';

import '../../notes/add_note_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int refreshTokenHigh = 0;

  bool isFetching = false;

  void refreshHigh() {
    setState(() {
      refreshTokenHigh++;
    });
  }

  @override
  void initState() {
    loadNoteList(); // 앱 실행시 Note 불러오기
    super.initState();
  }

  /* Note 불러오는 함수 */
  void loadNoteList() async {
    final directory = await getApplicationDocumentsDirectory();
    for (int i = 0;; i++) {
      if (!File('${directory.path}/note_$i.json').existsSync()) {
        return;
      }

      if (i == 0) {
        notes.clear();
      }

      String readJson =
          await File('${directory.path}/note_$i.json').readAsString();
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
    return Scaffold(
      appBar: buildAppBar(context),
      body: WelcomPageBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Notes",
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: textColorLight, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddNote()));
            /*         Scaffold(
              appBar: buildAppBar(context),
              body: AddNote(),
            );*/
          },
          icon: const Icon(Icons.add),
          color: textColorLight,
        ),
        IconButton(
          onPressed: () async {
            if (isFetching) return;
            setState(() {
              isFetching = true;
            });

            final directory = (await getApplicationDocumentsDirectory()).path;
            final dir = Directory("$directory/");

            final List<FileSystemEntity> entities = await dir.list().toList();
            final Iterable<File> files = entities.whereType<File>().toList();

            DatabaseReference databaseRef = FirebaseDatabase.instance.ref("/");
            databaseRef.set({});

            for (var file in files) {
              String extensionName = extension(file.path);
              if (extensionName == ".json") {
                String jsonString = await file.readAsString();

                String fileName = basenameWithoutExtension(file.path);
                await databaseRef
                    .child("jsons")
                    .child(fileName)
                    .set({"utf8": jsonString});
              }
              if (extensionName == ".png") {
                final pngUint8 = await file.readAsBytes();
                String fileName = basenameWithoutExtension(file.path);
                await databaseRef
                    .child("pngs")
                    .child(fileName)
                    .set({"base64": base64.encode(pngUint8)});
              }

              setState(() {
                isFetching = false;
              });
            }
          },
          icon: const Icon(Icons.upload),
          color: isFetching ? Colors.grey[100] : textColorLight,
        ),
        IconButton(
          onPressed: () async {
            if (isFetching) return;
            setState(() {
              isFetching = true;
            });

            DatabaseReference databaseRef = FirebaseDatabase.instance.ref("/");
            DataSnapshot snapshot = await databaseRef.get();
            if (snapshot.exists) {
              final directory = (await getApplicationDocumentsDirectory()).path;

              Map snapshotValue = snapshot.value as Map;
              Map jsons = snapshotValue["jsons"];
              for (String key in jsons.keys) {
                await File('$directory/$key.json')
                    .writeAsString(jsons[key]["utf8"]);
              }

              Map pngs = snapshotValue["pngs"];
              for (String key in pngs.keys) {
                await File('$directory/$key.png')
                    .writeAsBytes(base64.decode(pngs[key]["base64"]));
              }

              setState(() {
                loadNoteList();
                refreshTokenHigh++;
                isFetching = false;
              });
            }
          },
          icon: const Icon(Icons.download),
          color: isFetching ? Colors.grey[100] : textColorLight,
        ),
      ],
    );
  }
}
