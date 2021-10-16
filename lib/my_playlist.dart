
import 'package:flutter/material.dart';
import 'package:musicplayer/playlist_screen.dart';

class Myplaylist extends StatefulWidget {
  const Myplaylist({Key? key}) : super(key: key);

  @override
  _MyplaylistState createState() => _MyplaylistState();
}

class _MyplaylistState extends State<Myplaylist> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
          ListView(
            shrinkWrap: true,
            children: [
              Column(
                children:   [

                  ListTile(
                    title: const Text(
                      'New Playlist...',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.add),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: (){

                      },
                    ),
                    onTap: (){
                      _displayTextInputDialog(context);
                    },

                  ),
                  const Divider(
                    height: 20,
                    indent: 25,
                  ),
                  ListTile(
                    title: const Text(
                      'Liked Songs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    leading: IconButton(
                      icon: Image.asset('images/liked-songs.png'),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: (){
                      },
                    ),
                    onTap: (){},

                  ),
                ],
              )
            ],
          )
          ],
        ),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlaylistScreen()),
                      );
                    },
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
