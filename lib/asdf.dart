import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:musicplayer/PageManager.dart';
import 'package:musicplayer/colors.dart' as AppColors;

class MusicControlls extends StatefulWidget {
  dynamic songInfo;
  var songTitle;
  MusicControlls(
      {required this.songInfo, required this.changeTrack, required this.key, this.songTitle})
      : super(key: key);
  Function changeTrack;
  final GlobalKey<MusicControllsState> key;

  @override
  MusicControllsState createState() => MusicControllsState();
}

class MusicControllsState extends State<MusicControlls> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();

  var _audioPlayer;
  late final PageManager _pageManager;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    setSong(widget.songInfo);
    _pageManager = PageManager();
  }

  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(dynamic songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
    }
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        if (currentValue == maximumValue) {
          widget.changeTrack(true);
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  void nextSong() {
    setState(() {
      if (currentValue >= maximumValue) {
        widget.changeTrack(true);
      }
    });
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    final double Height = MediaQuery.of(context).size.height;
    final double Width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "TUNE " "Ax",
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Gemunu',
                  fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.back,
          leading: IconButton(
            padding: EdgeInsets.only(top: 5, left: 10),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 40,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.back,
                    Colors.black,
                  ])),
          child: Stack(
            children: [
              ///Play $ Pause///
              ///Play $ Pause///
              Positioned(
                top: Height - 180,
                child: Container(
                  width: Width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // IconButton(
                      //     iconSize: 25,
                      //     color: Colors.white,
                      //     onPressed: () {},
                      //     icon: Icon(Icons.shuffle)),
                      GestureDetector(
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 35,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.changeTrack(false);
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          changeStatus();
                        },
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 35,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          widget.changeTrack(true);
                        },
                      ),
                      // IconButton(
                      //   iconSize: 25,
                      //   color: Colors.white,
                      //   onPressed: () {},
                      //   icon: Icon(Icons.repeat),
                      // ),
                    ],
                  ),
                ),
              ),

              ///Slider///
              ///Slider///
              ///Slider///
              ///Slider///
              ///
// Positioned(
//   right: 20,
//   left: 20,
//   top: Height - 242,
//   child: ProgressBar(
//     progress: player.position,
//     total: player.position,
//     onSeek: (value) {
//       currentValue = value as double;
//       player.seek(Duration(milliseconds: currentValue.round()));
//     },
//     baseBarColor: Colors.grey,
//     progressBarColor: Colors.white,
//     thumbColor: Colors.white,
//     barHeight: 3,
//     timeLabelTextStyle: TextStyle(
//         color: Colors.white,
//         fontSize: 13,
//         height: 1.5,
//         fontFamily: "Gemunu"),
//   ),
// ),
              Positioned(
                right: 0,
                left: 0,
                top: Height - 242,
                child: Slider(
                  inactiveColor: Colors.grey,
                  activeColor: Colors.white,
                  min: minimumValue,
                  max: maximumValue,
                  value: currentValue,
                  onChanged: (value) {
                    currentValue = value;
                    player.seek(Duration(milliseconds: currentValue.round()));
                  },
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                top: Height - 205,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      currentTime,
                      style: TextStyle(color: Colors.white, fontFamily: 'Gemunu'),
                    ),
                    SizedBox(
                      width: 250,
                    ),
                    Text(
                      endTime,
                      style: TextStyle(color: Colors.white, fontFamily: 'Gemunu'),
                    )
                  ],
                ),
              ),

              ///Favourite Container///
              ///Favourite Container///
              ///Favourite Container///
              Positioned(
                top: Height - 320,
                right: 30,
                left: 30,
                child: Container(
                  width: Width,
// color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust volume",
                            divisions: 10,
                            min: 0.0,
                            max: 1.0,
                            value: player.volume,
                            stream: player.volumeStream,
                            onChanged: player.setVolume,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              ///subtitle///
              ///subtitle///
              ///subtitle///
              Positioned(
                right: 100,
                left: 100,
                top: Height / 3,
                child: Container(
                  child: Center(
                    child: Text(
                      widget.songTitle,overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey, fontSize: 20, fontFamily: "Titil"),
                    ),
                  ),
                  height: 100,
                  width: Width,
                ),
              ),

              ///Song Title///
              ///Song Title///
              ///Song Title///
              Positioned(
                right: 20,
                left: 20,
                top: Height / 3,
                child: Container(
                  height: 25,
                  child: Center(
                    child: Marquee(
                      blankSpace: 100,
                      text:
                      widget.songTitle,
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontFamily: "Titil"),
                    ),
                  ),
                ),
              ),

              ///Icon $ Images///
              ///Icon $ Images///
              ///Icon $ Images///
              Positioned(
                right: 100,
                left: 100,
                top: Height / 25,
                child: CircleAvatar(
                  radius: 105,
                  backgroundColor: AppColors.shade,
                  child: Icon(
                    Icons.music_note_outlined,
                    size: 100,
                    color: Colors.white,
                  ),
// child: ClipOval(
//   child: Image.asset(
//     "Assets/Selena-Gomez-640x514.jpg",
//     fit: BoxFit.cover,
//     height: Height,
//     width: Width,
//   ),
// ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.back,
      title: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Gemunu',
              fontWeight: FontWeight.bold,
              fontSize: 24.0)),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gemunu',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                inactiveColor: Colors.grey,
                activeColor: Colors.white,
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}