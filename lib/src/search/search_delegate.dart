import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {

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

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: son las sugerencias cuando esta tipiando

    final suggestList = (query.isEmpty)
        ? recentMovies
        : movies
            .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(suggestList[index]),
          onTap: () {
            selection = suggestList[index];
            showResults(context);
          },
        );
      },
    );
  }
}
