import 'package:flutter/material.dart';
import 'package:movie_app/models/tv_shows_model.dart';
import 'package:movie_app/service/tv_shows_services.dart';
import 'package:movie_app/widgets/tv_show_widget.dart';

class TvShowsPages extends StatefulWidget {
  const TvShowsPages({super.key});

  @override
  State<TvShowsPages> createState() => _TvShowsPagesState();
}

class _TvShowsPagesState extends State<TvShowsPages> {
  List<TVShow> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  //fetch Tv Shows
  Future<void> _fetchTvShows() async {
    try {
      List<TVShow> tvShows = await TvShowsServices().fetchTvShow();
      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (error) {
      print("Error:$error");
      setState(() {
        _error = "Failed to load tv Shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tv Shows Page")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : ListView.builder(
              itemCount: _tvShows.length,
              itemBuilder: (context, index) {
                return TvShowWidget(tvShow: _tvShows[index]);
              },
            ),
    );
  }
}
