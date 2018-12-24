import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'podcasts.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'episodedetail.dart';

class PodcastLocal {
  final String title;
  final String imageUrl;
  final String jsonUrl;
  PodcastLocal(this.title, this.imageUrl, this.jsonUrl);
}

final List<PodcastLocal> podcastlist = <PodcastLocal>[
  PodcastLocal('路书', "images/lushu.jpg", "data/lushu.json"),
  PodcastLocal('选美', "images/xuanmei.png", "data/xuanmei.json"),
  PodcastLocal('声东击西', "images/etw.jpg", "data/lushu.json"),
  PodcastLocal('7-Stories', "images/7-stories.jpg", "data/lushu.json"),
];

class PodcastGrid extends StatelessWidget {
  final List<PodcastLocal> podcastList;
  PodcastGrid(this.podcastList);
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
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
              padding: const EdgeInsets.all(5.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                    podcastLocal: podcastList[index],
                                  )),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60.0)),
                              child: Image.asset(
                                podcastList[index].imageUrl,
                                height: 120.0,
                                width: 120.0,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                podcastList[index].title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: podcastList.length,
                ),
              )),
        ],
      ),
    );
  }
}

Future<Podcast> fetchPodcast(PodcastLocal podcastLocal) async {
  final response = await rootBundle.loadString(podcastLocal.jsonUrl);
  return compute(podcast, response);
}

Podcast podcast(String responseBody) {
  Map podcastMap = jsonDecode(responseBody);
  var podcast = Podcast.fromJson(podcastMap);
  return podcast;
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
      body: FutureBuilder<Podcast>(
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
      ),
    );
  }
}



class Show extends StatelessWidget {
  final Podcast podcast;
  final PodcastLocal podcastLocal;
  Show({Key key, this.podcast, this.podcastLocal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
return 
    CustomScrollView(
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
                return
                InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EpisodeDetail(
                                    episodeItem: podcast.items[index],
                                    podcast: podcast,
                                  )
                                  ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            child: Image.asset(
                              podcastLocal.imageUrl,
                              height: 30.0,
                              width: 30.0,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          //   Text(podcastLocal.title, style: TextStyle(fontSize: 15.0, color: Colors.blue[900], fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                          Spacer(),
                          Text((podcast.items.length - index).toString(),
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.blue[900], fontFamily: 'ConcertOne')),
                        ],
                      ),
                      Container(
                        child: Text(
                          podcast.items[index].title,
                          style: TextStyle(fontSize: 15.0),
                          maxLines: 3,
                        ),
                      ),
                    ],
                  ),
                ),
                );
                 
              },
              childCount: podcast.items.length,
            ),
          ),
        ),
      ],
    );
  }
}
