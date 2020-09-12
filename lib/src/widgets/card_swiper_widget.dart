import 'package:flutter/material.dart';
import 'package:flutter_03/src/models/movie_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  List<Movie> movies = new List();

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSizen = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {

          movies[index].uniqueId = '${movies[index].id}-card';

          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detail',
                        arguments: movies[index]);
                  },
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/jar-loading.gif'),
                    image: NetworkImage(movies[index].getPosterImg()),
                    fit: BoxFit.cover,
                  ),
                )),
          );
        },
        itemCount: movies.length,
        itemHeight: _screenSizen.height * 0.5,
        itemWidth: _screenSizen.width * 0.7,
        layout: SwiperLayout.STACK,
      ),
    );
  }
}
