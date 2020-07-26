import 'package:flutter/material.dart';
import 'package:movieapp/model/movie_detail_response.dart';
import 'package:movieapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final MovieRepository _respository = MovieRepository();
  final BehaviorSubject<MovieDetailResponse> _subject =
      BehaviorSubject<MovieDetailResponse>();

  getMovieDetails(int id) async {
    MovieDetailResponse response = await _respository.getMovieDetail(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieDetailResponse> get subject => _subject;
}

final moviesDeailBloc = MovieDetailBloc();
