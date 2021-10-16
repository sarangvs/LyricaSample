// class Favourite extends StatefulWidget {
//   const Favourite({Key? key}) : super(key: key);
//
//   @override
//   _FavouriteState createState() => _FavouriteState();
// }
//
// class _FavouriteState extends State<Favourite> {
//   int favourite = 0;
//   dynamic songs;
//   late DatabaseHandler handler;
//   late final AudioPlayer player;
//   final OnAudioQuery audioQuery = OnAudioQuery();
//   late PageManager _pageManager;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageManager = PageManager();
//     handler = DatabaseHandler();
//     player = AudioPlayer();
//     addSongToPageManager(songs);
//     // handler.retrieveUsers();
//   }
//
//   Future<dynamic> addSongToPageManager(songs) async{
//     return await _pageManager.loadPlaylist(songs);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double Heights = MediaQuery.of(context).size.height;
//     final double Weights = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.shade,
//         body: Container(
//           padding: EdgeInsets.only(bottom: 60),
//           child: FutureBuilder(
//             future: this.handler.retrieveUsers(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
//               if (snapshot.hasData) {
//                 debugPrint("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGG:::$snapshot");
//                 return ListView.builder(
//                   itemCount: snapshot.data?.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           leading: QueryArtworkWidget(
//                             artworkBorder: BorderRadius.circular(8),
//                             nullArtworkWidget: Container(
//                                 width: Weights / 8,
//                                 height: Heights / 14,
//                                 decoration: BoxDecoration(
//                                     color: AppColors.back,
//                                     borderRadius: BorderRadius.circular(8)),
//                                 child: Icon(
//                                   Icons.music_note_outlined,
//                                   color: Colors.grey,
//                                   size: 45,
//                                 )),
//                             id: snapshot.data![index].num,
//                             type: ArtworkType.AUDIO,
//                             artworkFit: BoxFit.contain,
//                           ),
//                           trailing: IconButton(
//                             icon: Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                             ),
//                             onPressed: () async {
//                               await this
//                                   .handler
//                                   .deleteUser(snapshot.data![index].id!);
//                               setState(() {
//                                 snapshot.data!.remove(snapshot.data![index]);
//                               });
//                             },
//                           ),
//                           onTap: () {
//                             songs = snapshot.data![index].location;
//                             addSongToPageManager(songs);
//                             debugPrint("HAMNDFGNMNGFDFGNMNNDFB::::$songs");
//                             // player.setUrl(snapshot.data![index].location);
//                           },
//                           title: Text(
//                             snapshot.data![index].name,
//                             style: TextStyle(color: Colors.white, fontSize: 17),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                           subtitle: Text(
//                             snapshot.data![index].name,
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                         Divider(
//                           height: 0,
//                           indent: 85,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Track extends StatefulWidget {
//   @override
//   TrackState createState() => TrackState();
// }
//
// class TrackState extends State<Track> {
//   final OnAudioQuery audioQuery = OnAudioQuery();
//
//   late final AudioPlayer player;
//
//   List<SongModel> Tracks = [];
//
//   int currentIndex = 0;
//
//   int isFav = 0;
//   dynamic songTitle;
//   dynamic songId;
//   dynamic songLocation;
//   PageManager? _pageManager;
//
//   DatabaseHandler? handler;
//
//   void initState() {
//     _pageManager = PageManager();
//     super.initState();
//     player = AudioPlayer();
//     getTracks();
//     handler = DatabaseHandler();
//     requestPermission();
//     addUsers(songTitle, songId, songLocation);
//   }
//
//   Future<int> addUsers(songTitle, songId, songLocation) async {
//     User firstUser = User(
//       name: songTitle,
//       num: songId,
//       location: songLocation,
//     );
//     List<User> listOfUsers = [firstUser];
//     debugPrint("ADNAN:$songTitle");
//     debugPrint("ADNAN: $songId");
//     debugPrint("ADNAN: $songLocation");
//     debugPrint('nvhv  $listOfUsers');
//     return await handler!.insertUser(listOfUsers);
//   }
//
//   requestPermission() async {
//     // Web platform don't support permissions methods.
//     if (!kIsWeb) {
//       bool permissionStatus = await audioQuery.permissionsStatus();
//       if (!permissionStatus) {
//         await audioQuery.permissionsRequest();
//       }
//       setState(() {});
//     }
//   }
//
//   void getTracks() async {
//     Tracks = await audioQuery.querySongs();
//     setState(() {
//       Tracks = Tracks;
//     });
//   }
//
//   dynamic order = OnAudioQuery().querySongs(
//     sortType: SongSortType.DATE_ADDED,
//     orderType: OrderType.ASC_OR_SMALLER,
//     uriType: UriType.EXTERNAL,
//     ignoreCase: false,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final double Heights = MediaQuery.of(context).size.height;
//     final double Weights = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: AppColors.shade,
//       body: Container(
//         color: Colors.transparent,
//         padding: EdgeInsets.only(bottom: 60, top: 15),
//         child: FutureBuilder<List<SongModel>>(
//           future: order,
//           builder: (context, item) {
//             if (item.data != null) {
//               return ListView.builder(
//                   itemCount: Tracks.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (Tracks[index].data.contains("mp3")) {
//                       return Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               dynamic songs = Tracks[index].data;
//                               _pageManager!.loadPlaylist(songs);
// // Navigator.of(context).push(MaterialPageRoute(
// //     builder: (context) => MusicPlayerScreen(
// //           songInfo: songs[currentIndex],
// //         )));
//                             },
//                             child: ListTile(
//                               leading: QueryArtworkWidget(
//                                 artworkBorder: BorderRadius.circular(8),
//                                 nullArtworkWidget: Container(
//                                     width: Weights / 8,
//                                     height: Heights / 14,
//                                     decoration: BoxDecoration(
//                                         color: AppColors.back,
//                                         borderRadius: BorderRadius.circular(8)),
//                                     child: Icon(
//                                       Icons.music_note_outlined,
//                                       color: Colors.grey,
//                                       size: 45,
//                                     )),
//                                 id: Tracks[index].id,
//                                 type: ArtworkType.AUDIO,
//                                 artworkFit: BoxFit.contain,
//                               ),
//                               title: Text(
//                                 Tracks[index].title,
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 17),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                               subtitle: Text(
//                                 Tracks[index].displayNameWOExt,
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               trailing: PopupMenuButton(
//                                   icon: Icon(
//                                     Icons.more_vert,
//                                     color: Colors.grey,
//                                   ),
//                                   color: AppColors.back,
//                                   itemBuilder: (context) => [
//                                     PopupMenuItem(
//                                       child: Text(
//                                         "Delete",
//                                         style:
//                                         TextStyle(color: Colors.white),
//                                       ),
//                                       value: 1,
//                                     ),
//                                     PopupMenuItem(
//                                       child: Text(
//                                         "Add to Favourite",
//                                         style:
//                                         TextStyle(color: Colors.white),
//                                       ),
//                                       onTap: () {
//                                         setState(() {
//                                           songTitle = Tracks[index].title;
//                                           songId = Tracks[index].id;
//                                           songLocation = Tracks[index].data;
//                                           addUsers(songTitle, songId,
//                                               songLocation);
//                                         });
//                                       },
//                                       value: 2,
//                                     ),
//                                     PopupMenuItem(
//                                       child: Text(
//                                         "Stop",
//                                         style:
//                                         TextStyle(color: Colors.white),
//                                       ),
//                                       onTap: () {
//                                         player.setUrl(Tracks[index].data);
//                                         currentIndex = index;
//                                         player.stop();
//                                       },
//                                       value: 2,
//                                     )
//                                   ]),
//                             ),
//                           ),
//                           Divider(
//                             height: 0,
//                             indent: 85,
//                             color: Colors.grey,
//                           ),
//                         ],
//                       );
//                     }
//                     return Container(
//                       height: 0,
//                     );
//                   });
//             }
//             return CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }