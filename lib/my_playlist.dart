import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:musicplayer/main.dart';
import 'package:musicplayer/playlist_screen.dart';
import 'package:path_provider/path_provider.dart';

class Myplaylist extends StatefulWidget {
  const Myplaylist({Key? key}) : super(key: key);

  @override
  _MyplaylistState createState() => _MyplaylistState();
}

class _MyplaylistState extends State<Myplaylist> {

  /// CREATE FOLDER IN APP
  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
    Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
      await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
         ///FUNCTION FOR CALLING CALLFOLDERCREATION....
  callFolderCreationMethod(String folderInAppDocDir) async {
    // ignore: unused_local_variable
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    print(actualFileName);
    setState(() {});
  }

          ///SHOW DIALOGUE BOX FOR ADDING FOLDER
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Playlist',
              style: TextStyle(
                  fontFamily: 'Roboto', fontWeight: FontWeight.bold)
              ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: _textFieldController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Create new playlist'),
                onChanged: (val) {
                  setState(() {
                    userInput = _textFieldController.text;
                    print(userInput);
                  });
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                if (userInput != null) {
                  await callFolderCreationMethod(userInput);
                  getDir();
                  setState(() {
                    _folders.clear();
                    userInput = null;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

///FOLDER LIST
  late List<FileSystemEntity> _folders;
  Future<void> getDir() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    print(_folders);
  }
///DELETE DIALOGUE BOX
  Future<void> _showDeleteDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete this playlist?',
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes', style: TextStyle(
        color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
              onPressed: () async {
                await _folders[index].delete();
                getDir();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No', style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  final TextEditingController _textFieldController = TextEditingController();
  late var userInput;


  @override
  void initState() {
    _folders=[];
    getDir();
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.add,color: Colors.black,),
        title: const Text('New Playlist...',style: TextStyle(color: Colors.black,fontSize: 18),),
      ), onTap: () {
          print('appbar print');
          _showMyDialog();
      },
      ),
      body: Stack(
        children: [
    ListView.builder(
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 20,
      //   vertical: 25,
      // ),
      itemBuilder: (context, index) {
        return Container(
              width: double.infinity,
            //  padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: getFileType(_folders[index]),
                      builder: (ctx,snapshot){
                          return  ListTile(
                            leading : const Icon(
                                Icons.folder,
                                size: 20,
                                color: Colors.grey,
                              ),
                            title:    Text(_folders[index].path.split('/').last),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: (){
                                _showDeleteDialog(index);
                              },
                            ),
                          );
                        }

                        ),
                ],
              ),
            );
      },
      itemCount: _folders.length,
    ),

    ]
    )
    );
  }
  Future getFileType(file)
  {

    return file.stat();
  }
}

///CUSTOM APP BAR FOR ONTAP
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

   CustomAppBar({ required this.onTap,required this.appBar}) ;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(onTap: onTap,child: appBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}