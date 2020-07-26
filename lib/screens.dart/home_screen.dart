import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/widgets/genres.dart';
import 'package:movieapp/widgets/now_playing.dart';
import 'package:movieapp/widgets/persons.dart';
import 'package:movieapp/widgets/top_movies.dart';
import '../style/theme.dart' as Style;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Style.Colors.mainColor,
        leading: Icon(EvaIcons.menu2Outline,color: Colors.white,),
        title: Text('MovieApp'),
        actions: <Widget>[
          IconButton(icon: Icon(EvaIcons.searchOutline,color: Colors.white,), onPressed: null)
        ],
      ),
      body: ListView(
        children: <Widget>[
          NowPlaying(),
          GenresScreen(),
          PersonsList(),
          TopMovies(),
        ],
      ),
    );
  }
}