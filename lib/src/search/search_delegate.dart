import 'package:flutter/material.dart';
import 'package:flutter_03/src/models/movie_model.dart';
import 'package:flutter_03/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  
  final moviesProvider = new MoviesProvider();

  String selection = '';

  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Iron man',
    'Capitan america'
  ];

  final recentMovies = ['Spiderman', 'Capitan america'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: actions of the appbar like Cancel and an icon
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: Icono a la izquierda del appbar
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: builder para crear y mostrar los resultados
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
        child: Text(selection),
      ),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // TODO: son las sugerencias cuando esta tipiando
  //
  //   final suggestList = (query.isEmpty)
  //       ? recentMovies
  //       : movies
  //           .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();
  //
  //   return ListView.builder(
  //     itemCount: suggestList.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(suggestList[index]),
  //         onTap: () {
  //           selection = suggestList[index];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: son las sugerencias cuando esta tipiando

    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future:  moviesProvider.searchMovie(query),
      initialData: <Movie>[],
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot){
        if(snapshot.hasData){

          final movies = snapshot.data;

          return ListView(

            children: movies.map((movie){
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    image: NetworkImage(movie.getPosterImg()),
                    placeholder: AssetImage('assets/images/jar-loading.gif'),
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: (){
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, '/detail',arguments: movie);
                },
              );
            }).toList()
          );
        }else{
          return Container();
        }
      },
    );

  }
}
