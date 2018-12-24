import 'package:flutter/material.dart';
import 'podcasts.dart';

class EpisodeDetail extends StatelessWidget{
  final EpisodeItem episodeItem;
  final Podcast podcast;
  EpisodeDetail({this.episodeItem,this.podcast});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(episodeItem.title),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                   width: 300, 
                   child: Text(episodeItem.summary, maxLines: 3,),
                  ),
                  
                  Text(episodeItem.attachments.length.toString()),
                ],
              ),
            ),
            Text(episodeItem.contentText),
          ],
        ),
      ),
    );
  }
}