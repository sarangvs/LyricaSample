import 'package:flutter/widgets.dart';
import 'package:musicplayer/song_screen.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';



class SongSearch extends SearchDelegate<String>{
  late final List<SongModel> songs;

  SongSearch({required this.songs});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){},
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
  return IconButton(
      onPressed: (){
        close(context, query);
      },
      icon: const Icon(Icons.arrow_back_ios)
  );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggesstions = songs.where((songs){
      return songs.toString().contains(query.toLowerCase());
    });
    return ListView.builder(
        itemCount: suggesstions.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(
              suggesstions.elementAt(index).toString(),
            ),
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggesstions = songs.where((songs){
      return songs.toString().contains(query.toLowerCase());
    });
      return ListView.builder(
        itemCount: suggesstions.length,
          itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(
              suggesstions.elementAt(index).toString(),
            ),
          );
          }
      );
  }
  
}