import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/service/movie_service.dart';
import 'package:movie_app/widgets/movie_details.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  List<Movie> _movies = [];
  int _totalPages = 1;
  int _currentPage = 1;
  bool _isLoading = false;

  //method to fetch movies
  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Movie> fetchedMovies = await MovieService().fetchNowPlayingMovies(
        page: _currentPage,
      );

      setState(() {
        _movies = fetchedMovies;
        _totalPages = 100;
      });
    } catch (error) {
      print("Error$error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //previous page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  //go to next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Now Playing Page")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index > _movies.length - 1) {
                        return _buildPaginationControls();
                      } else {
                        return MovieDetailWidget(movie: _movies[index]);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? _previousPage : null,
          child: Text("Previous"),
        ),

        const SizedBox(width: 8),
        Text('page $_currentPage of $_totalPages'),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _currentPage < _totalPages ? _nextPage : null,
          child: Text("Next"),
        ),
      ],
    );
  }
}
