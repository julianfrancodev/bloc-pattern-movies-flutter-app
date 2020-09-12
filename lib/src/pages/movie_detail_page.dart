import 'package:flutter/material.dart';
import 'package:flutter_03/src/models/actor_model.dart';
import 'package:flutter_03/src/models/movie_model.dart';
import 'package:flutter_03/src/providers/movies_provider.dart';

class MovieDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
      body: Center(
          child: CustomScrollView(
            slivers: <Widget>[
              _renderAppBar(movie),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 10,
                  ),
                  _renderPosterTitle(context, movie),
                  _renderDescription(movie),
                  _renderCasting(movie)

                ]),
              )
            ],
          )),
    );
  }

  Widget _renderAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.amber,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            movie.title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          background: FadeInImage(
            placeholder: AssetImage('assets/images/jar-loading.gif'),
            image: NetworkImage(
              movie.getBackgroundImg(),
            ),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 150),
          )),
    );
  }

  Widget _renderPosterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString())
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _renderDescription(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Text(movie.overView, textAlign: TextAlign.justify,),
    );
  }

  Widget _renderCasting(Movie movie) {
    final moviesProvider = new MoviesProvider();
    moviesProvider.getCast(movie.id.toString());
    return FutureBuilder(
      future: moviesProvider.getCast(movie.id.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _renderActorPageView(snapshot.data);
        }
        else {
          return Container();
        }
      },
    );
  }

  Widget _renderActorPageView(List<Actor> actors) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,

        ),
        itemCount: actors.length,
        itemBuilder: (context, index) {
          Actor actor = actors[index];
          return _renderCardActor(actor);
        },
      ),
    );
  }

  Widget _renderCardActor(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/images/jar-loading.gif'),
              image: NetworkImage(actor.getProfileImg()),
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }

}



