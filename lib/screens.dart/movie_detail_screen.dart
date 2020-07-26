import 'package:flutter/material.dart';
import 'package:movieapp/bloc/get_movie_video_bloc.dart';
import 'package:movieapp/model/video.dart';
import 'package:movieapp/model/video_response.dart';
import 'package:sliver_fab/sliver_fab.dart';
import '../model/movie.dart';
import '../style/theme.dart' as Style;

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({Key key, @required this.movie}) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Movie movie;
  _MovieDetailScreenState(this.movie);
  @override
  void initState() {
    super.initState();
    movieVideosBloc..getMovieVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(
            right: 20,
          ),
          floatingWidget: StreamBuilder<VideoResponse>(
            stream: movieVideosBloc.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return _buildErrorWidget(snapshot.data.error);
                } else {
                  return _buildVideoWidget(snapshot.data);
                }
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
          expandedHeight: 200,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Style.Colors.mainColor,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  movie.title.length > 40
                      ? movie.title.substring(0, 37) + "..."
                      : movie.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original/' +
                                      movie.backPoster)),
                          shape: BoxShape.rectangle),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.black.withOpacity(0.0)
                          ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoadingWidget() {
    return Column();
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

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }
}
