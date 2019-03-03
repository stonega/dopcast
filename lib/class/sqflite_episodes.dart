import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webfeed/webfeed.dart';
import 'episodebrief.dart';

class DBEpisode {
  static Database _db;
  Future<Database> get databaseEp async {
    if (_db != null) return _db;
    _db = await initDbEp();
    return _db;
  }

  initDbEp() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "episodes.db");
    Database theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Episodes(id INTEGER PRIMARY KEY,title TEXT, enclosure_url TEXT, enclosure_length INTEGER, pubDate TEXT, description TEXT, feed_title TEXT, feed_link TEXT)");
  }

  void savePodcastRss(String rss) async {
    var p = RssFeed.parse(rss);
    for (int i = 0; i < p.items.length; i++) {
      print(p.items[i].title);
      print(p.title);
      var dbEpClient = await databaseEp;
      await dbEpClient.transaction((txn)  {
        return  txn.rawInsert(
            'INSERT INTO Episodes(title, enclosure_url, enclosure_length, pubDate, description, feed_title, feed_link) VALUES(?, ?, ?, ?, ?, ?, ?)',
            [
              p.items[i].title,
              p.items[i].enclosure.url,
              p.items[i].enclosure.length,
              p.items[i].pubDate,
              p.items[i].description,
              p.title,
              p.link
            ]);
      });

    }
    print(p.items.length);
  }

  Future<List<EpisodeBrief>> getRssItem(String title) async {
    var dbEPClient = await databaseEp;
    List<Map> list = await dbEPClient
        .rawQuery('SELECT * FROM Episodes where feed_title = ?',[title]);
    List<EpisodeBrief> episodes = List();
    for (int x = 0; x<list.length; x++) {
      episodes.add(EpisodeBrief(
          list[x]['title'],
          list[x]['enclosure_url'],
          list[x]['enclosure_length'],
          list[x]['pubDate'],
          list[x]['description']));
    }
    print(episodes.length);
    print(title);
    return episodes;
  }
}
