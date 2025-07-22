import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/service/movie_service.dart';
import 'package:movie_app/widgets/movie_details.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie> _movie = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  //This method fetches the upcoming movies from the api and this method is called in the initStete method.

  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));
      try {
        final newMovies = await MovieService().fetchUpcommingMovies(
          page: _currentPage,
        );
        setState(() {
          if (newMovies.isEmpty) {
            _hasMore = false;
          } else {
            _movie.addAll(newMovies);
            _currentPage++;
          }
        });
      } catch (error) {
        print("Error $error");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
      appBar: AppBar(
        title: Text(
          "Vista Paradias",
          style: TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            _fetchMovies();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _movie.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movie.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final Movie movie = _movie[index];
            return MovieDetailWidget(movie: movie);
          },
        ),
      ),
    );
  }
}
