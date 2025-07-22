import 'package:flutter/material.dart';

class TvShowsPages extends StatefulWidget {
  const TvShowsPages({super.key});

  @override
  State<TvShowsPages> createState() => _TvShowsPagesState();
}

class _TvShowsPagesState extends State<TvShowsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Tv Shows Page")));
  }
}
