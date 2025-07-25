import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/models/tv_shows_model.dart';
import 'package:http/http.dart' as http;

class TvShowsServices {
  final String _apikey = dotenv.env['TMDB_API_KEY'] ?? "";

  Future<List<TVShow>> fetchTvShow() async {
    try {
      //base url
      final String BaseUrl = "https://api.themoviedb.org/3/tv";
      //popular tv shows
      final popularResponse = await http.get(
        Uri.parse("$BaseUrl/popular?api_key=$_apikey"),
      );

      //airing today tv shows
      final airingTodayResponse = await http.get(
        Uri.parse("$BaseUrl/airing_today?api_key=$_apikey"),
      );

      //top rated tv shows
      final topRatedResponse = await http.get(
        Uri.parse("$BaseUrl/top_rated?api_key=$_apikey"),
      );

      if (popularResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          topRatedResponse.statusCode == 200) {
        final popularData = json.decode(popularResponse.body);
        final airingData = json.decode(airingTodayResponse.body);
        final topRatedData = json.decode(topRatedResponse.body);

        final List<dynamic> popularResults = popularData['results'];
        final List<dynamic> airingResults = airingData['results'];
        final List<dynamic> topRatedResults = topRatedData['results'];

        List<TVShow> tvShows = [];
        tvShows.addAll(
          popularResults.map((tvData) => TVShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          airingResults.map((tvData) => TVShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          topRatedResults.map((tvData) => TVShow.fromJson(tvData)).take(10),
        );
        return tvShows;
      } else {
        throw Exception("Faild to load tv shows.");
      }
    } catch (error) {
      print("Error fetching tv show $error");
      return [];
    }
  }
}
