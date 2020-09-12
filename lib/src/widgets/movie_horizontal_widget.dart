import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_03/src/models/movie_model.dart';

class MovieHorizontalWidget extends StatelessWidget {
  List<Movie> movies;
  Function nextPage;

  MovieHorizontalWidget({@required this.movies, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        // children: _renderCards(),
        itemBuilder: (context, index){
          Movie movie = movies[index];
          return _renderSingleCard(context, movie);
        },
      ),
    );
  }

  Widget _renderSingleCard(BuildContext context,Movie movie){
    movie.uniqueId = '${movie.id}-poster';

    final movieCard = Container(
      margin: EdgeInsets.only(right: 15, top: 30),
      child: Column(
        children: [
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/images/jar-loading.gif'),
                fit: BoxFit.cover,
                height: 155,
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: (){
       Navigator.pushNamed(context, '/detail',arguments: movie);
      },
      child: movieCard,
    );
  }

  List<Widget> _renderCards() {
    return movies.map((movie) {
      return Container(
        margin: EdgeInsets.only(right: 15, top: 30),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/images/jar-loading.gif'),
                fit: BoxFit.cover,
                height: 155,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );
    }).toList();
  }
}
