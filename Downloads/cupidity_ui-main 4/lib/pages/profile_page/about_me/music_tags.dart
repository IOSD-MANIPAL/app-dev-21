import 'package:flutter/material.dart';

class MusicTags extends StatefulWidget {
  @override
  _MusicTagsState createState() => _MusicTagsState();
}

class _MusicTagsState extends State<MusicTags> {
  final List<String> music = ["Pop", "Bollywood", "Folk & Acoustic", "Hip Hop"];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: music.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            buildMusicName(0),
            buildMusicName(1),
            buildMusicName(2),
          ],
        );
      },
    );
  }

  Widget buildMusicName(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: 35,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Pop"),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
