import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';



class DemoPlayScreen extends StatefulWidget {
  const DemoPlayScreen({Key? key}) : super(key: key);

  @override
  _DemoPlayScreenState createState() => _DemoPlayScreenState();
}

class _DemoPlayScreenState extends State<DemoPlayScreen> {
  double minimumValue=0.0, maximumValue=0.0, currentValue=0.0;
  String currentTime='', endTime='';

  // final Duration _duration = const Duration();
  // final Duration _position = const Duration();

  // late AudioPlayer advancedPlayer;

  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentValue = minimumValue;
    maximumValue = audioPlayer.position.inMilliseconds.toDouble();

      setState(() {
        currentTime=getDuration(currentValue);
        endTime=getDuration(maximumValue);
      });
      audioPlayer.positionStream.listen((duration) {
        currentValue=duration.inMilliseconds.toDouble();
      });
     setState(() {
        currentTime=getDuration(currentValue);
      });

  }

  @override
  void dispose() {
    audioPlayer.dispose();
  }

  void changeToSecond(int second){
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }
  String getDuration(double value)  {
    Duration duration=Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds].map((element)=>element.remainder(60).toString().padLeft(2, '0')).join(':');
  }



  int fav = 0;
  int shuffle = 0;
  int repeat = 0;
  int play = 0;


  bool isPlaying=false;
  bool isPaused=false;

  final List<IconData> _icons=[
    Icons.play_circle_fill,
    Icons.pause_circle_filled,
  ];

  @override
  Widget build(BuildContext context) {
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[50],
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: Height - 168,
                  child: const Image(
                    image: AssetImage('images/playmusic.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        debugPrint('Back button clicked');
                        Navigator.pop(context);
                      },
                    ),

                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: Height / 2.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.zero, topRight: Radius.circular(70)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: fav == 0
                                  ? const Icon(Icons.favorite_border)
                                  : const Icon(
                                Icons.favorite,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                debugPrint("fav button");
                                setState(() {
                                  fav == 0 ? fav = 1 : fav = 0;
                                });
                              },
                            ),
                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            IconButton(
                              icon: shuffle == 0
                                  ? const Icon(Icons.shuffle)
                                  : const Icon(
                                Icons.shuffle,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                debugPrint("Shuffle button");
                                setState(() {
                                  shuffle == 0 ? shuffle = 1 : shuffle = 0;
                                });
                              },
                            ),
                            // SizedBox(
                            //   width: Width / 5,
                            // ),
                            IconButton(
                              icon: repeat == 0
                                  ? const Icon(Icons.repeat)
                                  : const Icon(
                                Icons.repeat,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                debugPrint("repeat button");
                                setState(() {
                                  repeat == 0 ? repeat = 1 : repeat = 0;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          width: Width,
                          child: Marquee(
                            text: "The Kid LAROI, Justin Bieber - STAY",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'roboto',
                                color: Colors.redAccent),
                            blankSpace: 150,
                            velocity: 50,
                          ),
                        ),
                        const Text('Justin Bieber'),
                        const SizedBox(
                          height: 10,
                        ),



                        SizedBox(
                          width: Width,
                          height: 25,
                          child: Slider(
                            min:minimumValue,
                            max: maximumValue,
                            value: currentValue,
                            activeColor: Colors.orange,
                            inactiveColor: Colors.grey,
                            onChanged: (value) {
                              currentValue = value;
                              audioPlayer.seek(Duration(milliseconds: currentValue.round()));

                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 22,right: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(currentTime,style: const TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500)),
                              Text(endTime, style: const TextStyle(color: Colors.grey, fontSize: 12.5, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 50,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.fast_rewind,
                                size: 30,
                              ),
                              onPressed: () {
                                debugPrint('previous');
                              },
                              //       padding: const EdgeInsets.all(8.0),
                            ),
                            SizedBox(
                              height: 90,
                              width: 90,
                              child: IconButton(
                                iconSize: 70,
                                color: Colors.red,
                                icon:isPlaying==false? Icon(_icons[0]):Icon(_icons[1]),
                                onPressed: ()async{
                                  await audioPlayer.setAsset('Assets/Stay_192.mp3');
                                  audioPlayer.play();
                                  if(isPlaying==false){
                                    setState(() {
                                      isPlaying = true;
                                    });
                                  }else if(isPlaying==true){
                                    audioPlayer.pause();
                                    setState(() {
                                      isPlaying=false;
                                    });
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.fast_forward,
                                size: 30,
                              ),
                              onPressed: () {
                                debugPrint('next');
                              },
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}
