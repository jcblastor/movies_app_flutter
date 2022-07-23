import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:movies_app/models/models.dart';
import 'package:movies_app/helpers/helpers.dart';
import 'package:movies_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'cfd6347885ae0374e8afe307a6bde4dd';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final deboucer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(
      _baseUrl,
      endpoint,
      {'api_key': _apiKey, 'language': _language, 'page': '$page'},
    );

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    // asignamos de la response lo que necesitamos a una variable
    onDisplayMovies = nowPlayingResponse.results;
    // notifyListener avisa a todos los widges que usen esta info para
    // renderizar si algo cambio
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {'api_key': _apiKey, 'language': _language, 'query': query},
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    deboucer.value = '';
    deboucer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      deboucer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
