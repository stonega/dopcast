import 'package:flutter/material.dart';
import 'class/searchpodcast.dart';
import 'class/podcastlocal.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget appBarTitle = Text(
    "Search Example",
    style: TextStyle(color: Colors.blue),
  );
  Icon icon = Icon(
    Icons.search,
    color: Colors.blue,
  );
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  bool _isSearching;
  bool _subscribed;
  String _searchText = '';

  _MyHomePageState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = '';
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isSearching = false;
    _subscribed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: globalKey,
      appBar: buildAppBar(context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: _controller.text.isNotEmpty
                  ? FutureBuilder(
                      future: getList(_searchText),
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        List content = snapshot.data;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: content.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Image.network(
                                    content[index].image,
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center,
                                  ),
                                ),
                                title: Text(content[index].title),
                                subtitle: Text(content[index].publisher),
                                trailing: !_subscribed
                               ? OutlineButton(
                                child: Text('Subscribe', style:TextStyle(color: Colors.blue)),
                                onPressed: (){
                                  _subscribe(content[index].title);})
                               : OutlineButton(
                                child: Text('Subscribed'),
                                onPressed: null),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text('Search'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _subscribe(String t) {
    podcastlist.add(PodcastLocal(t, "images/7-stories.jpg", "data/lushu.json"));
    setState(() {
          _subscribed = !_subscribed;
        });
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.blue,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                autofocus: true,

                style: new TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: "Search...",
                  // hintStyle:  TextStyle(color: Colors.black)
                ),
                // onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = Icon(
        Icons.search,
        color: Colors.blue,
      );
      this.appBarTitle = Text(
        "Search Sample",
        style: new TextStyle(color: Colors.blue),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  static Future<List> getList(String searchText) async {
    String url =
        "https://listennotes.p.mashape.com/api/v1/search?only_in=title&q=" +
            searchText +
            "&sort_by_date=0&type=podcast";
    final response = await http.get(url, headers: {
      'X-Mashape-Key': "UtSwKG4afSmshZfglwsXylLKJZHgp1aZHi2jsnSYK5mZi0A32T",
      'Accept': "application/json"
    });
    Map searchResultMap = jsonDecode(response.body);
    var searchResult = SearchPodcast.fromJson(searchResultMap);
    return searchResult.results;
  }
}
