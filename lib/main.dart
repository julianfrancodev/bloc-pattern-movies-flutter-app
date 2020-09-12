import 'package:flutter/material.dart';
import 'package:flutter_03/src/pages/home_page.dart';
import 'package:flutter_03/src/pages/movie_detail_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/detail': (context) => MovieDetailPage()
    },
  ));
}
