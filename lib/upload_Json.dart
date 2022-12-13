import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'notes/notes.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}): super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // PlatformFile? pickedFile;
  UploadTask? uploadTask;

  /*Future selectFile() async{
    //await Firebase.initializeApp();
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }*/

  Future uploadFile() async{
    //await Firebase.initializeApp();
    final dir = await getApplicationDocumentsDirectory();
    for(int i = 0; i < notes.length; i++) {
      final path = '${dir.path}/note_$i.json';
      final file = File(path);

      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urlDownload');
    }

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Upload File'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*ElevatedButton(
            child: const Text('Select File'),
            onPressed: selectFile,
          ),*/
          const SizedBox(height: 32),
          ElevatedButton(
            child: const Text('Upload File'),
            onPressed: uploadFile,
          ),
        ],
      ),
    ),
  );

}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  DownloadTask? downloadTask;

  Future downloadFile() async{
    final dir = await getApplicationDocumentsDirectory();
    for(int i = 0; i < notes.length; i++) {
      final path = '${dir.path}/note_$i.json';
      final file = File(path);

      // print(file);
      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        downloadTask = ref.writeToFile(file);
      });

      final snapshot = await downloadTask!.whenComplete(() {});

      // final urlDownload = await snapshot.ref.getDownloadURL();
      //print('Download Link: $urlDownload');
    }

    setState(() {
      downloadTask = null;
    });
  }



  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Download File'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*ElevatedButton(
            child: const Text('Select File'),
            onPressed: selectFile,
          ),*/
          const SizedBox(height: 32),
          ElevatedButton(
            child: const Text('Download File'),
            onPressed: downloadFile,
          ),
        ],
      ),
    ),
  );
}