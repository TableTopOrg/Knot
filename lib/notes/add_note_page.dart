import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:knot/pages/welcome/welcome_page.dart';
import 'dart:core';
import '../pages/audio_record/audio_record.dart';
import 'notes.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String title = "", thumbnail;
    int time;

    return Container(
        color: Colors.white,
        //  width: 300,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: CupertinoTextField(
                controller: _titleEditController,
                placeholder: "Enter the Title of Note",
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                onChanged: (text) {
                  title = text;
                },
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              child: const Text("Ok"),
              onPressed: () {
                int imageNum = (notes.length + 1) % 3;
                if (imageNum == 0) {
                  imageNum = 3;
                }
                thumbnail = "assets/images/image_$imageNum.png";
                Note n =
                    Note(title: title, thumbnail: thumbnail, time: getDate());

                notes.add(n);
                saveNoteList();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomePage()));
                // Navigator.pop(context);
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleEditController.dispose();
    super.dispose();
  }
}

int getDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyymmdd');

  return int.parse(formatter.format(now));
}
