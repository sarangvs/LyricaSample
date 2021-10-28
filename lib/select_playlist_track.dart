import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Database/playlist_folder_handler.dart';
import 'package:musicplayer/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'Database/playlist_songs.dart';

class SelectPlaylistSongs extends StatefulWidget {
  int playlistiddd;

  SelectPlaylistSongs({Key? key, required this.playlistiddd}) : super(key: key);

  @override
  _SelectPlaylistSongsState createState() => _SelectPlaylistSongsState();
}

class _SelectPlaylistSongsState extends State<SelectPlaylistSongs> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  int? songID_2;
  int? playlistID_2;
  String? songName_2;
  String? path_2;
  List<SongModel> playlistsongs = [];

  // int currentIndex = 0;
  // int add =0;
  late PlaylistDatabaseHandler playlistSongHandler;

  @override
  void initState() {
    super.initState();
    playlistSongHandler = PlaylistDatabaseHandler();
    getTracks();
    addUsers(songID_2, playlistID_2, songName_2, path_2);
  }

  void getTracks() async {
    playlistsongs = await audioQuery.querySongs();
    setState(() {
      playlistsongs = playlistsongs;
    });
  }

  Future<int> addUsers(songID_2, playlistID_2, path_2, songName_2) async {
    PlaylistSongs firstUser = PlaylistSongs(
        path: path_2,
        songName: songName_2,
        songID: songID_2,
        playlistID: playlistID_2);
    List<PlaylistSongs> listOfUsers = [firstUser];
    print("songtilte:$songName_2");
    print("songid: $songID_2");
    print("songdata: $path_2");
    print('song playlist id$playlistID_2');
    print('list of users $listOfUsers');
    return await playlistSongHandler.insertSongs(listOfUsers);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Select Songs',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
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
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
          sortType: SongSortType.DISPLAY_NAME,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const CircularProgressIndicator();
          }
          if (item.data!.isEmpty) {
            return const Text("Nothing found!");
          }

          return ListView.builder(
            itemCount: playlistsongs.length,
            itemBuilder: (context, index) {
              if (playlistsongs[index].data.contains("mp3")) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //currentIndex = index;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => PlayScreen(
                        //       //  changeTrack: changeTrack,
                        //         songInfo: songs[currentIndex],
                        //         Key: Key,
                        //         //TODO : GLOBAL KEY
                        //       ),
                        //     ));
                      },
                      child: ListTile(
                        title: Text(
                          playlistsongs[index].title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          playlistsongs[index].artist ?? "Unknown Artist",
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: SizedBox(
                          height: Height / 7,
                          width: Width / 7,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            //   : const Icon(
                            // Icons.check,
                            // color: Colors.orange,

                            onPressed: () {
                              setState(() {
                                songID_2 = playlistsongs[index].id;
                                playlistID_2 = widget.playlistiddd;
                                songName_2 = playlistsongs[index].title;
                                path_2 = playlistsongs[index].data;
                                addUsers(
                                    songID_2, playlistID_2, songName_2, path_2);
                                // add == 0 ? add = 1 : add = 0;
                              });
                            },
                          ),
                        ),
                        leading: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(10),
                          id: playlistsongs[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueGrey),
                            child: const Icon(
                              Icons.audiotrack,
                              color: Colors.white,
                            ),
                            height: 50,
                            width: 50,
                          ),
                        ),
                        onTap: () {
                          //addPlaylistSongs(songID_2, playlistID_2, songName_2, path_2);
                        },
                      ),
                    ),
                    const Divider(
                      height: 0,
                      indent: 5,
                    )
                  ],
                );
              }
              return Container(
                height: 0,
              );
            },
          );
        },
      ),
    ));
  }
}
