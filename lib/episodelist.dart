import 'package:flutter/material.dart';
import 'episode.dart';

class EpisodeList extends StatelessWidget {
  EpisodeList(this.data);
  final List<Episode> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) =>
            GetEpisode(data[index]),
      ),
    );
  }
}

class GetEpisode extends StatelessWidget {
  const GetEpisode(this.episode);
  final Episode episode;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      ),
      width: 180.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Image.asset("images/lushu.jpg", height: 80.0, width:180.0, fit: BoxFit.fitWidth, alignment: Alignment.topCenter,),
          ),
          Text(episode.title),
          Text(episode.shownote.substring(0,30)),
        ],
      ),
    );
  }
}
