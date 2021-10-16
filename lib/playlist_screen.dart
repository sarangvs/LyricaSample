import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final TextEditingController _textFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 30,
            right: 0,
            height: Height / 8,
            child: const Text("Liked Songs",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          ),
          Positioned(
            top: 0,
            left: Width - 40,
            right: 0,
            height: Height / 26,
            child: InkWell(
              child: const Icon(Icons.playlist_add),
              onTap: () {
                debugPrint('playlist button clicked');
                _displayTextInputDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                title: const Text(
                  'New Playlist',
                  style: TextStyle(
                      fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                ),
                content: TextField(
                  onChanged: (value) {},
                  controller: _textFieldController,
                  decoration: const InputDecoration(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Done',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          );
        });
  }
}



