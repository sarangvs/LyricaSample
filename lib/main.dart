import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/favourites.dart';
import 'package:musicplayer/my_playlist.dart';
import 'package:musicplayer/searchbar.dart';
import 'package:musicplayer/select_playlist_track.dart';
import 'package:musicplayer/settings.dart';
import './song_screen.dart';
import './play_screen.dart';
import 'managers/page_manager.dart';
import 'managers/service.dart';
import 'package:musicplayer/searchbar.dart';



void main() async{
  await setupServiceLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
 ]);
  runApp(
   const MyApp(),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: Appbar(),
    );
  }
}

class Appbar extends StatefulWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  _AppbarState createState() => _AppbarState();
}

var obj =   Songscreen();

class _AppbarState extends State<Appbar> {


  bool isSearching = false;
  final GlobalKey<PlayScreenState> Key= GlobalKey<PlayScreenState>();

  late final PageManger _pageManager;
  //late final PlayScreen _playScreen;
  late final Songscreen _songscreen;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManger();
    _songscreen =  const Songscreen();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    _songscreen =  const Songscreen();
    super.dispose();
  }


  int playbutton = 0;
  var pages = [
      const Songscreen(),
    const Myplaylist(),
    const Favourites(),
  ];

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return DefaultTabController(length: 3,
    child:SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: !isSearching? const Text(
          'Lyrica',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Exo2'),
        ): const TextField(decoration: InputDecoration(
          hintText: 'Search'
        ),
          style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            padding:
                const EdgeInsets.only(left: 35, right: 0, top: 0, bottom: 0),
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchBar(),));
              });
              debugPrint('search button pressed');
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            onPressed: () {
              debugPrint('Settings button print');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Settingspage()));
            },
          ),
        ],
        bottom: const TabBar(
          indicatorColor: Colors.black54,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.black87,
          labelStyle: TextStyle(fontSize: 14,fontFamily: 'Exo2',fontWeight: FontWeight.w500),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          tabs: [
            Tab(text: 'SONGS',),
            Tab(text: 'PLAYLIST',),
            Tab(text: 'FAVOURITES',),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(

            children:pages,
          ),
          // Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     height: Height / 7,
          //     child: GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) =>  PlayScreen(changeTrack: changeTrack, songInfo:songs[currentIndex], Key: Key,)),
          //         );
          //       },
          //       child: Container(
          //         child: Column(
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: [
          //                 const SizedBox(width: 4,),
          //                 SizedBox(
          //                   width: Width * 7 / 10,
          //                   child: Center(
          //                     child: RichText(
          //                       text: const TextSpan(
          //                         text: "The Kid LAROI, Justin Bieber - STAY",
          //                         style: TextStyle(
          //                             fontSize: 16,
          //                             fontWeight: FontWeight.bold,
          //                             fontFamily: 'roboto',
          //                             color: Colors.black87),
          //                         children: [],
          //                       ),
          //                       overflow: TextOverflow.ellipsis,maxLines: 1,
          //                     ),
          //                   ),
          //                 ),
          //
          //                 Expanded(
          //                       child: SizedBox(
          //                         height: Height / 7,
          //                         width: Width / 8,
          //                         child: ValueListenableBuilder<ButtonState>(
          //                             valueListenable: _pageManager.buttonNotifier,
          //                             builder: (_,value,__){
          //                               switch(value){
          //                                 case ButtonState.paused:
          //                                   return IconButton(
          //                                     icon: const Icon(Icons.play_circle_fill),
          //                                     iconSize: 70,
          //                                     color: Colors.redAccent,
          //                                     onPressed: (){
          //                                       _pageManager.play();
          //                                     },
          //                                   );
          //                                 case ButtonState.playing:
          //                                   return IconButton(
          //                                     icon: const Icon(Icons.pause_circle_filled),
          //                                     iconSize: 70,
          //                                     color: Colors.redAccent,
          //                                     onPressed: (){
          //                                       _pageManager.pause();
          //                                     },
          //                                   );
          //                               }
          //                             }
          //                         )
          //                       ),
          //                       ),
          //
          //               ],
          //             ),
          //           ],
          //         ),
          //         decoration: const BoxDecoration(
          //           borderRadius:
          //               BorderRadius.only(topRight: Radius.circular(60)),
          //           color: Colors.white,
          //         ),
          //       ),
          //     ))
        ],
      ),
    )
    )
    );
  }
}

