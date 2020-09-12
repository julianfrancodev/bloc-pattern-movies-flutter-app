import 'package:flutter/material.dart';
import 'package:flutter_03/src/models/movie_model.dart';
import 'package:flutter_03/src/providers/movies_provider.dart';
import 'package:flutter_03/src/search/search_delegate.dart';
import 'package:flutter_03/src/widgets/card_swiper_widget.dart';
import 'package:flutter_03/src/widgets/movie_horizontal_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final moviesProvider = new MoviesProvider();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    moviesProvider.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Movies',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_swiperCards(), _slider(context)],
            ),
          ),
        ));
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      initialData: <Movie>[],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
              height: 400, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _slider(context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Text(
            'Populares',
            style: Theme.of(context).textTheme.headline6,
          ),
          StreamBuilder(
            initialData: <Movie>[],
            stream: moviesProvider.popularsStream,
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return MovieHorizontalWidget(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPopularMovies,
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
