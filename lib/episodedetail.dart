import 'package:flutter/material.dart';
import 'class/podcasts.dart';
import 'secondpage.dart';
import 'player.dart';
import 'class/podcastlocal.dart';
import 'package:webfeed/webfeed.dart';
import 'package:flutter_html/flutter_html.dart';

class EpisodeDetail extends StatelessWidget {
  final RssItem episodeItem;
  final RssFeed podcast;
  final PodcastLocal podcastLocal;
  EpisodeDetail({this.episodeItem, this.podcast, this.podcastLocal, Key key})
      : super(key: key);
  var textstyle = TextStyle(fontSize: 15.0, color: Colors.white);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          episodeItem.title,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: <Widget>[
                          AudioApp(episodeItem.enclosure.url),
                          Container(
                            margin: EdgeInsets.only(left: 100.0, top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  width: 50.0,
                                  height: 25.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                      ((episodeItem.enclosure.length
                                                      ) ~/
                                                  1000000)
                                              .toString() +
                                          'MB',
                                      style: textstyle),
                                ),
                                Container(
                                  width: 10.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  width: 70.0,
                                  height: 25.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    ((episodeItem.enclosure.length
                                                   ) ~/
                                                60)
                                            .toString() +
                                        'mins',
                                    style: textstyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 5.0),
                child: SingleChildScrollView(
                  child: Html(data: episodeItem.description),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
