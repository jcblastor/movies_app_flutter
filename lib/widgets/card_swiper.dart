import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:movies_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiper({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.45,
        itemBuilder: (BuildContext context, int index) {
          // sacamos cada list a una variable
          final movie = movies[index];
          // creamos un id-unico para hacer la animacion del hero
          movie.heroId = 'swiper-${movie.id}';
          // gesturedDetector registra el tap y navega a la ruta
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: movie,
            ),
            // ClipRRect nos permite redondear las imagenes
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // fadeInImage nos permite monejar las imagenes y poner holderImage
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
