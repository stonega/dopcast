import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'episode.dart';
import 'episodelist.dart';
import 'firstpage.dart';
import 'secondpage.dart';
import 'player.dart';

void main() 
  async{
  try {
    await FlutterStatusbarcolor.setStatusBarColor(Color(0x00000000));
  }  catch (e) {
    print(e);
  }

  runApp(
    MaterialApp(
      title: 'TsacDop',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: TsacDop(),
    ),
  );
}

class TsacDop extends StatefulWidget {
  TsacDop({Key key}) : super(key: key);

  @override
  _TsacDopState createState() => _TsacDopState();
}

class _TsacDopState extends State<TsacDop> {
  int _selectedIndex = 1;
  final _widgetOptions = [
    Center(child: FirstPage()),
    PodcastGrid(podcastlist),
    AudioApp('http://www.rxlabz.com/labz/audio2.mp3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Playlist'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Podcast'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('School'),
              backgroundColor: Colors.red),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

