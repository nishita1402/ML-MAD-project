import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:project/file_list.dart';
import 'package:open_file/open_file.dart';

import 'file_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String fileType = 'Audio';
  var fileTypeList = ['Audio'];


  
//  Future<void> _getPrediction() async {
//      const apiUrl = 'http://10.0.2.2:5000/predict';

//  final response = await http.post(Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode());

//  if (response.statusCode == 200) {
//  setState(() {

//  prediction = double.parse(response.body);

//  });

//  } else {

//  throw Exception('Failed to get prediction');

//  }

//  var request = http.MultipartRequest('POST', Uri.parse('https://example.com/upload'));
//   request.files.add(await http.MultipartFile.fromPath('file', file.path));
//   var response = await request.send();
//   if (response.statusCode == 200) {
//     print('File uploaded');
//   } else {
//     print('Error uploading file');
//   }

// }

  FilePickerResult? result;
  PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selected File Type:  ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                DropdownButton(
                  value: fileType,
                  items: fileTypeList.map((String type) {
                    return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(fontSize: 20),
                        ));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      fileType = value!;
                      file = null;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                pickFiles(fileType);
              },
              child: Text('Pick file'),
            ),
            if (file != null) fileDetails(file!),
            if (file != null) ElevatedButton(onPressed: (){viewFile(file!);},child: Text('View Selected File'),)
            // else (file == null) ElevatedButton(onPressed: (){viewFile(file!);},child: Text('View Selected File'),)
         
          ],
        ),
      ),
    );
  }

  Widget fileDetails(PlatformFile file){
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size  = (mb>=1)?'${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('File Name: ${file.name}'),
          Text('File Size: $size'),
          Text('File Extension: ${file.extension}'),
          Text('File Path: ${file.path}'),
        ],
      ),
    );

  }

  void pickFiles(String? filetype)  async {
    switch (filetype) {
    //   case ' ':
    //     result = await FilePicker.platform.pickFiles(type: FileType.image);
    //     if (result == null) return;
    //   //   file = result!.files.first;
    //   //   setState(() {});
    //     break;



  //     // case 'Image':
  //     //   result = await FilePicker.platform.pickFiles(type: FileType.image);
  //     //   if (result == null) return;
  //     //   file = result!.files.first;
  //     //   setState(() {});
  //     //   break;
  //     // case 'Video':
  //     //   result = await FilePicker.platform.pickFiles(type: FileType.video);
  //     //   if (result == null) return;
  //     //   file = result!.files.first;
  //     //   setState(() {});
  //     //   break;

      case 'Audio':
        result = await FilePicker.platform.pickFiles(type: FileType.audio) ;
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
  //     // case 'All':
  //     //   result = await FilePicker.platform.pickFiles();
  //     //   if (result == null) return;
  //     //   file = result!.files.first;
  //     //   setState(() {});
  //     //   break;
  //     // case 'MultipleFile':
  //     //   result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //     //   if (result == null) return;
  //     //   loadSelectedFiles(result!.files);
  //     //   break;
    }
  }

  // multiple file selected
  // navigate user to 2nd screen to show selected files
  void loadSelectedFiles(List<PlatformFile> files){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FileList(files: files, onOpenedFile:viewFile ))
    );
  }

  // open the picked file
  void viewFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}