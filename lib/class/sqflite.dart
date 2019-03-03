import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'podcastlocal.dart';

class DBHelper{
  static Database _db;
  Future<Database> get database async {
    if (_db!=null)
    return _db;
    _db = await initDb();
    return _db;
  }

initDb() async{
  io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "podcasts.db");
  Database theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
  return theDb;
}

void _onCreate(Database db, int version) async{
  await db.execute(
    "CREATE TABLE PodcastLocal(id INTEGER PRIMARY KEY,title TEXT, imageUrl TEXT,rssUrl TEXT)"
   );
}

Future<List<PodcastLocal>> getPodcastLocal() async {
  var dbClient = await database;
  List<Map> list = await dbClient.rawQuery('SELECT * FROM PodcastLocal');
  List<PodcastLocal> podcastLocal = List();
  for (int i=0; i<list.length; i++) {
    podcastLocal.add(PodcastLocal(list[i]['title'], list[i]['imageUrl'], list[i]['rssUrl']));
  }
  print(podcastLocal.length);
  return podcastLocal;
}

void savePodcastLocal(PodcastLocal podcastLocal) async {
  print('save');
  var dbClient= await database;
  await dbClient.transaction(
    (txn) async{
      return await txn.rawInsert(
        'INSERT INTO PodcastLocal(title, imageUrl, rssUrl) VALUES('+'\''+podcastLocal.title+'\''+','+'\''+podcastLocal.imageUrl+'\''+','+'\''+podcastLocal.rssUrl+'\''+')'
      );
    }
  );
}
}