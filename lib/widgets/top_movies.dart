import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieapp/bloc/get_movies_bloc.dart';
import 'package:movieapp/model/movie.dart';
import 'package:movieapp/model/movie_response.dart';
import '../style/theme.dart' as Style;

class TopMovies extends StatefulWidget {
  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 10,
            top: 20,
          ),
          child: Text(
            'TOP RATED MOVIES',
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<MovieResponse>(
          stream: moviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildMoviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
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

  Widget _buildMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('No Movies'),
          ],
        ),
      );
    } else {
      return Container(
        height: 270,
        padding: EdgeInsets.only(
          left: 10,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              child: Column(
                children: <Widget>[
                  movies[index].poster == null
                      ? Container(
                          width: 120,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Style.Colors.secondColor,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                EvaIcons.filmOutline,
                                color: Colors.white,
                                size: 50,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: 120,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster),
                                fit: BoxFit.cover),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    height: 15,
                    child: Text(
                      movies[index].title,
                      maxLines: 2,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        movies[index].rating.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      RatingBar(
                        itemSize: 8,
                        initialRating: movies[index].rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2),
                        itemBuilder: (context, _) => Icon(
                          EvaIcons.star,
                          color: Style.Colors.secondColor,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
