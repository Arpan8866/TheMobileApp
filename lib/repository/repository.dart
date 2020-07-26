import 'package:dio/dio.dart';
import 'package:movieapp/model/cast_response.dart';
import 'package:movieapp/model/genre_response.dart';
import 'package:movieapp/model/movie_detail_response.dart';
import 'package:movieapp/model/movie_response.dart';
import 'package:movieapp/model/person_response.dart';
import 'package:movieapp/model/video_response.dart';
import '../key.dart';

class MovieRepository {
  static final ApiKey api = ApiKey();
  final apiKey = api.apiKey;
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();
  var getPopularUrl = "$mainUrl/movie/top_rated";
  var getMoviesUrl = "$mainUrl/discover/movie";
  var getPlayingUrl = "$mainUrl/movie/now_playing";
  var getGenresrUrl = "$mainUrl/genre/movie/list";
  var getPersonsrUrl = "$mainUrl/trending/person/week";
  var movieUrl = "$mainUrl/movie";

  Future<MovieResponse> getMovies() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page': 1};
    try {
      Response response =
          await _dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error occured msg:$error stacktrace:$stackTrace");
      return MovieResponse.withError(error);
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page': 1};
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);

      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error occured msg:$error stacktrace:$stackTrace");
      return MovieResponse.withError(error);
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {'api_key': apiKey};
    try {
      Response response =
          await _dio.get(getGenresrUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error occured msg:$error stacktrace:$stackTrace");
      return GenreResponse.withError(error);
    }
  }

  Future<PersonResponse> getPersons() async {
    var params = {'api_key': apiKey};
    try {
      Response response =
          await _dio.get(getPersonsrUrl, queryParameters: params);
      return PersonResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error occured msg:$error stacktrace:$stackTrace");
      return PersonResponse.withError(error);
    }
  }

  Future<MovieResponse> getMoviesByGenre(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
      'page': 1,
      'with_genres': id
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print("error occured msg:$error stacktrace:$stackTrace");
      return MovieResponse.withError(error);
    }
  }

  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try {
      Response response =
          await _dio.get(movieUrl + "$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (e, stactrace) {
      print("Error Occured:$e and $stactrace");
      return MovieDetailResponse.withError(e);
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try {
      Response response = await _dio.get(movieUrl + "$id" + "/credits",
          queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (e, stactrace) {
      print("Error Occured:$e and $stactrace");
      return CastResponse.withError(e);
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try {
      Response response = await _dio.get(movieUrl + "$id" + "/similar",
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (e, stactrace) {
      print("Error Occured:$e and $stactrace");
      return MovieResponse.withError(e);
    }
  }

  Future<VideoResponse> getMovieVideos(int id) async {
    var params = {
      'api_key': apiKey,
      'language': 'en-US',
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/videos",
          queryParameters: params);
     
      return VideoResponse.fromJson(response.data);
    } catch (e, stactrace) {
     
      print("Error Occured:$e and $stactrace");
      return VideoResponse.withError(e);
    }
  }
}
