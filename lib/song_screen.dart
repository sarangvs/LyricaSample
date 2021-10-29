import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Database/db.dart';
import 'package:musicplayer/play_screen.dart';
import 'package:musicplayer/searchbar.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'Database/database_handler.dart';

class Songscreen extends StatefulWidget {
  const Songscreen({Key? key}) : super(key: key);

  @override
  _SongscreenState createState() => _SongscreenState();}

class _SongscreenState extends State<Songscreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer player = AudioPlayer();
  List<SongModel> songs = [];
  int currentIndex = 0;
  final GlobalKey<PlayScreenState> Key = GlobalKey<PlayScreenState>();

  @override
  void initState() {
    super.initState();
    getTracks();
    requestPermission();
  }

  requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      //setState(() {});
    }
  }

  void getTracks() async {
    songs = await _audioQuery.querySongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    Key.currentState!.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Center(
            child: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
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
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    int songImage = songs[index].id;
                    if (songs[index].data.contains("mp3")) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              currentIndex = index;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayScreen(
                                      changeTrack: changeTrack,
                                      songInfo: songs[currentIndex],
                                      Key: Key,
                                      //TODO : GLOBAL KEY
                                    ),
                                  ));
                            },
                            child: ListTile(
                              title: Text(
                                songs[index].title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                songs[index].artist ?? "Unknown Artist",
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                id: songs[index].id,
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
          ),

        ],
      ),
    ));
  }
}
