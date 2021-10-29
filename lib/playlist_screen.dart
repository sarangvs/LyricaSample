import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/playlist_songs.dart';
import 'package:musicplayer/select_playlist_track.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'Database/playlist_folder_handler.dart';



class PlaylistScreen extends StatefulWidget {
  dynamic playlistfolderID;
   PlaylistScreen({Key? key,required this.playlistfolderID}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

  PlaylistDatabaseHandler? _playlistDatabaseHandler;
  late final AudioPlayer player;
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    _playlistDatabaseHandler = PlaylistDatabaseHandler();
    player = AudioPlayer();
  }



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
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
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
            child: const Text(
              "Liked Songs",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Positioned(
            top: 0,
            left: Width - 40,
            right: 0,
            height: Height / 26,
            child: InkWell(
              child: const Icon(Icons.playlist_add),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPlaylistSongs(playlistiddd: widget.playlistfolderID,),));
                debugPrint('playlist button clicked');
              },
            ),
          ),
          Positioned(
            top: 28,
              height: Height,
              width: Width,
              child:  FutureBuilder(
                future: this._playlistDatabaseHandler!.retrieveSongs(),
                builder: (BuildContext context, AsyncSnapshot<List<PlaylistSongs>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: const Icon(Icons.delete_forever),
                          ),
                          key: ValueKey<int>(snapshot.data![index].id!),
                          onDismissed: (DismissDirection direction) async {
                            await _playlistDatabaseHandler!.deleteSongs(snapshot.data![index].id!);
                            setState(() {
                              snapshot.data!.remove(snapshot.data![index]);
                            });
                          },
                          child: ListTile(
                            title: Text(snapshot.data![index].path,overflow: TextOverflow.ellipsis,),
                            subtitle: Text(snapshot.data![index].path ,overflow: TextOverflow.ellipsis,),
                            trailing: SizedBox(
                              height: Height / 7,
                              width: Width / 7,
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.orange,
                                size: 42,
                              ),
                            ),
                            leading: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(10),
                              id: snapshot.data![index].songID,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueGrey
                                ),
                                child: const Icon(Icons.audiotrack,color: Colors.white,),
                                height: 50,
                                width: 50,
                              ),
                            ),
                               onTap: (){
                              null;
                               },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
          )
        ],
      ),

    );
  }
}
