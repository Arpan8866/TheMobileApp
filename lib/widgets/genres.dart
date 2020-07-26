import 'package:flutter/material.dart';
import 'package:movieapp/bloc/get_genres_bloc.dart';
import 'package:movieapp/model/genre.dart';
import 'package:movieapp/model/genre_response.dart';
import 'package:movieapp/widgets/genres_list.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  @override
  void initState() {
    genresBloc.getGenres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildGenresWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 220,
            child: Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 4,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Error Occured:$error'),
        ],
      ),
    );
  }

  Widget _buildGenresWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('No Genres'),
          ],
        ),
      );
    } else {
      return GenresList(genres: genres);
    }
  }
}
