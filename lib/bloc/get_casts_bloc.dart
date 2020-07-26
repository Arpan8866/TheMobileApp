import 'package:flutter/material.dart';
import 'package:movieapp/model/cast_response.dart';
import 'package:movieapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CastBloc {
  final MovieRepository _respository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();

  getCasts(int id) async {
    CastResponse response = await _respository.getCasts(id);
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

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castsBloc = CastBloc();
