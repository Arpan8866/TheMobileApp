import 'package:flutter/material.dart';
import 'package:movieapp/bloc/get_movies_byGenre_bloc.dart';
import 'package:movieapp/model/genre.dart';
import 'package:movieapp/widgets/genre_movies.dart';
import '../style/theme.dart' as Style;

class GenresList extends StatefulWidget {
  final List<Genre> genres;
  GenresList({Key key, @required this.genres}) : super(key: key);
  @override
  _GenresListState createState() => _GenresListState(genres);
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  final List<Genre> genres;
  _GenresListState(this.genres);
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc..drainStream();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Style.Colors.mainColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.Colors.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor: Style.Colors.titleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 15,
                    ),
                    child: Text(
                      genre.name.toUpperCase(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: genres.map((genre) {
              return GenreMovies(genreId: genre.id);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
