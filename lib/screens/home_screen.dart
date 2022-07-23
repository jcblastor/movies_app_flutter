import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:movies_app/providers/providers.dart';
import '../searchs/searchs.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // aca acedemos a los datos .of<MoviesProvider> busca los datos
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Movies')),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate(),
            ),
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // card Swiper
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            // listado horizontal de peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
