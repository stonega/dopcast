import 'package:flutter/material.dart';
import 'podcasts.dart';
import 'secondpage.dart';

class EpisodeDetail extends StatelessWidget {
  final EpisodeItem episodeItem;
  final Podcast podcast;
  final PodcastLocal podcastLocal;
  EpisodeDetail({this.episodeItem, this.podcast, this.podcastLocal, Key key})
      : super(key: key);
  var textstyle =
      TextStyle(fontFamily: 'ConcertOne', fontSize: 25.0, color: Colors.red);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(podcast.title),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  alignment: Alignment.topLeft,
                                  width: 300.0,
                                  child: Text(
                                    episodeItem.title,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(12.0),
                                  width: 300.0,
                                  child: Text(((episodeItem.attachments[0]
                                                  .sizeInBytes) ~/
                                              1000000)
                                          .toString() +
                                      'M'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        width: 100.0,
                        height: 100.0,
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 2.0,
                                  spreadRadius: 0.5,
                                ),
                              ]),
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                  ((episodeItem.attachments[0].sizeInBytes) ~/
                                              1000000)
                                          .toString() +
                                      'mb',
                                  style: textstyle),
                              Text(
                                ((episodeItem.attachments[0]
                                                .durationInSeconds) ~/
                                            60)
                                        .toString() +
                                    'mins',
                                style: textstyle,
                              ),
                              Text(
                                '0played',
                                style: textstyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Text(episodeItem.contentText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
