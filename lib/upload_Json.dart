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

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot){
        if(snapshot.hasData){
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(100 * progress).roundToDouble()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )

          );
        }
        else{
          return const SizedBox(height: 50);
        }
      }
  );

}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  late Future<ListResult> futureFiles;
  //Map<int, double> downloadProgress = {};

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('/json').listAll();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Download Json'),
    ),
    body: FutureBuilder<ListResult>(
      future: futureFiles,
      builder: (context, snapshot){
        if(snapshot.hasData){
          final files = snapshot.data!.items;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index)
          {
            final file = files[index];

            return ListTile(
              title: Text(file.name),
              trailing: IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.black,
                ),

              onPressed: () => downloadFile(index, file),
              ),
            );
          },
          );

        }
        else if(snapshot.hasError){
          return const Center(child: Text('Error occurred'));
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    ),
  );



  Future downloadFile(int index, Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded ${ref.name}')),
    );
  }
}