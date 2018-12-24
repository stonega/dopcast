import 'package:flutter/material.dart';
import 'episodelist.dart';
import 'episode.dart';

class FirstPage extends StatelessWidget {
  var titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30.0,
    color: Colors.blue,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Recent Update',style: titleStyle),
          EpisodeList(update),
          Padding(padding: EdgeInsets.all(10.0),),
          Text('Favorite', style: titleStyle),
          EpisodeList(update),
          Padding(padding: EdgeInsets.all(10.0),),
          Text('Past', style: titleStyle),
          EpisodeList(update),
        ],
      ),
    );
  }
}
