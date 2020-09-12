import 'dart:async';
import 'dart:convert';

import 'package:flutter_03/src/models/actor_model.dart';
import 'package:flutter_03/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey = '0682e2fb20c2d0bc413cc38ba6b6e44d';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularPage = 0;
  bool _loadingPopular = false;


  List<Movie> _populars = new List();

  final _popularsStreamController = new StreamController<
      List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _popularsStreamController.sink.add;

  Stream<List<Movie>> get popularsStream => _popularsStreamController.stream;

  void disposeStreams() {
    _popularsStreamController?.close();
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '/3/movie/now_playing', {
      "api_key": _apiKey,
      'language': _languaje
    });

    http.get(url);

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    print(decodedData['results']);
    final movies = await new Movies.fromJsonList(decodedData['results']);


    return movies.items;
  }

  Future<List<Movie>> getPopularMovies() async {
    if (_loadingPopular) return [];

    _loadingPopular = true;

    _popularPage++;

    var url = Uri.https(_url, '/3/movie/popular', {
      "api_key": _apiKey,
      "language": _languaje,
      "page": _popularPage.toString()
    });


    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    _populars.addAll(movies.items);
    popularsSink(_populars);

    _loadingPopular = false;

    return movies.items;
  }


  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '/3/movie/${movieId}/credits', {
      "api_key": _apiKey,
    });

    final resp = await http.get(url);
    print(resp);
    final decodedData = json.decode(resp.body);
    print(decodedData);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    print(cast);
    return cast.actors;
  }


}