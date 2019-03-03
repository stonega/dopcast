import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'class/podcasts.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'episodedetail.dart';
import 'class/podcastlocal.dart';
import 'package:webfeed/webfeed.dart';
import 'class/sqflite_localpodcast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'class/episodebrief.dart';
import 'class/sqflite_episodes.dart';

Future<List<PodcastLocal>> getPodcastLocal() async {
  var dbHelper = DBHelper();
  // for(int i=0; i<podcastlist.length; i++){
  //  dbHelper.savePodcastLocal(podcastlist[i]);
  //   }
  Future<List<PodcastLocal>> podcastList = dbHelper.getPodcastLocal();
  return podcastList;
}

class PodcastGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Podcast'),
          elevation: 0.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder<List<PodcastLocal>>(
            future: getPodcastLocal(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverPadding(
                        padding: const EdgeInsets.all(5.0),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.0,
                            crossAxisCount: 3,
                            mainAxisSpacing: 10.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PodcastDetail(
                                              podcastLocal:
                                                  snapshot.data[index],
                                            )),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(60.0)),
                                        child: Container(
                                          height: 120.0,
                                          width: 120.0,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                snapshot.data[index].imageUrl,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                          ),
                                        ),
                                        // child: Image.network(
                                        //  snapshot.data[index].imageUrl,
                                        //  height: 120.0,
                                        //  width: 120.0,
                                        //  fit: BoxFit.fitWidth,
                                        //   alignment: Alignment.topCenter,
                                        //   ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(
                                          snapshot.data[index].title,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: snapshot.data.length,
                          ),
                        )),
                  ],
                );
              }
              return Text('NOData');
            },
          ),
        ));
  }
}

Future<RssFeed> fetchPodcast(PodcastLocal podcastLocal) async {
  final response = await http.get(podcastLocal.rssUrl);
  return compute(podcast, response.body);
}

RssFeed podcast(String responseBody) {
  var podcast = RssFeed.parse(responseBody);
  return podcast;
}

Future<List<EpisodeBrief>> getRssItem(PodcastLocal podcastLocal) async {
  var dbEpHelper = DBEpisode();
  Future<List<EpisodeBrief>> episodes = dbEpHelper.getRssItem(podcastLocal.title);
  return episodes;
}

class PodcastDetail extends StatelessWidget {
  PodcastDetail({Key key, this.podcastLocal}) : super(key: key);
  final PodcastLocal podcastLocal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(podcastLocal.title),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
      ),
      body: FutureBuilder<List<EpisodeBrief>>(
        future: getRssItem(podcastLocal),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Show(podcast: snapshot.data, podcastLocal: podcastLocal)
              : Center(child: CircularProgressIndicator());
        },
      ),
/*       body: FutureBuilder<RssFeed>(
        future: fetchPodcast(podcastLocal),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Show(
                  podcast: snapshot.data,
                  podcastLocal: podcastLocal,
                )
              : Center(child: CircularProgressIndicator());
        },
      ), */
    );
  }
}

class Show extends StatelessWidget {
  final List<EpisodeBrief> podcast;
  final PodcastLocal podcastLocal;
  Show({Key key, this.podcast, this.podcastLocal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(5.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.0,
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EpisodeDetail(
                                episodeItem: podcast[index],
                                podcast: podcast,
                                podcastLocal: podcastLocal,
                              )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.grey[200],
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100],
                            blurRadius: 1.0,
                            spreadRadius: 0.5,
                          ),
                        ]),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: CachedNetworkImage(
                                      imageUrl: podcastLocal.imageUrl,
                                    ),
                                  ),
                                  //child: Image.network(
                                  // podcastLocal.imageUrl,
                                  // height: 30.0,
                                  // width: 30.0,
                                  // fit: BoxFit.fitWidth,
                                  // alignment: Alignment.center,
                                  // ),
                                ),
                              ),
                              //   Text(podcastLocal.title, style: TextStyle(fontSize: 15.0, color: Colors.blue[900], fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                              Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text((podcast.length - index).toString(),
                                    style: TextStyle(
                                        fontSize: 35.0,
                                        color: Colors.blue[300],
                                        fontFamily: 'ConcertOne')),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text(
                              podcast[index].title,
                              style: TextStyle(fontSize: 15.0),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              podcast[index].pubDate.substring(0, 10),
                              style: TextStyle(color: Colors.grey[900]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: podcast.length,
            ),
          ),
        ),
      ],
    );
  }
}
