import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:path_provider/path_provider.dart';

import 'notes/notes.dart';

Future<void> uploadFile() async {

  Directory dir = await getApplicationDocumentsDirectory();
  for(int i = 0;i < notes.length; i++) {
    File uploadTofile = File('${dir.path}/note_$i.json');
    String fileToUpload = 'json/note_$i.json';

    try{
      await FirebaseStorage.instance
          .ref(fileToUpload)
          .putFile(uploadTofile);
    } on FirebaseException catch (e){
      //print(e);
    }
  }

}

Future<void> downloadFile() async{

  Directory downloadDir = await getApplicationDocumentsDirectory();
  for(int i = 0;i<notes.length;i++) {
    File downloadToFile = File('${downloadDir.path}/note_$i.json');
    String fileToDownload = 'json/note_$i.json';

    try {
      await FirebaseStorage.instance
          .ref(fileToDownload)
          .writeToFile(downloadToFile);
    } on FirebaseException catch (e) {
      //print(e);
    }
  }
}