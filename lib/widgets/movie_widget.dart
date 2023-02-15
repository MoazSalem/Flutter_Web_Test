import 'package:flutter/material.dart';
import 'package:netflix_web/models/movies.dart';
import 'package:netflix_web/screens/movie_info.dart';

// This is the widget that is shown per movie in the main page.
Widget movieWidget({required Movie movie, required BuildContext context}) {
  final currentWidth = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: () => Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MovieInfo(movie: movie))),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            width: 500,
            height: 700,
            child: Image.network(
                fit: BoxFit.fill, "https://image.tmdb.org/t/p/w500${movie.posterPath}"),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(200, 0, 0, 0),
                  Color.fromARGB(20, 0, 0, 0),
                  Color.fromARGB(0, 0, 0, 0)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: FittedBox(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth * 20 / (currentWidth),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
