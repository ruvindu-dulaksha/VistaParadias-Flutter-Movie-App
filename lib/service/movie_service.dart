import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieService {
  //get api get key from .env
  final String _apikey = dotenv.env["TMDB_API_KEY"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  //fetch all upcoming movies
  Future<List<Movie>> fetchUpcommingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/upcoming?api_key=$_apikey&page=$page"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (error) {
      print("Error fetching upcomming movis $error");
      return [];
    }
  }

  //fetcg all now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/upcoming?api_key=$_apikey&page=$page"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> result = data["results"];

        return result.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Error fetching now playing ovies");
      }
    } catch (error) {
      print("Error ftching now playing movies $error");
      return [];
    }
  }

  //search movie by query

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apikey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Error searching movie");
      }
    } catch (error) {
      print("Error search movies $error");
      throw Exception("Failed to search movie :$error");
    }
  }
}
