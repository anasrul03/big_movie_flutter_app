import 'package:big_movie_app/keys/movie_card_keys.dart';
import 'package:big_movie_app/models/movie_model.dart';
import 'package:big_movie_app/views/widgets/movie_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  group('MovieCardWidget Tests', () {
    // Arrange
    final movie = Movie(
      adult: false,
      backdropPath: 'backdrop_path',
      genreIds: [28, 12],
      id: 1,
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview of the movie',
      popularity: 10.0,
      posterPath: 'invalid/path/to/image.jpg',
      // Invalid path to trigger error
      releaseDate: '2024-01-01',
      title: 'Movie Title',
      video: false,
      voteAverage: 7.0,
      voteCount: 100,
    );
    testWidgets('Displays shimmer effect when movie is null',
        (WidgetTester tester) async {
      // Arrange
      const widget = MovieCardWidget(movie: null);

      // Act
      await tester.pumpWidget(const MaterialApp(home: widget));

      expect(find.byKey(movieCardLoadingKey), findsOneWidget);
    });

    testWidgets('Displays movie poster when movie is provided',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(MaterialApp(home: MovieCardWidget(movie: movie)));

      expect(find.byKey(movieCardKey("1")), findsOneWidget);
    });

    testWidgets('Displays error icon when image fails to load',
        (WidgetTester tester) async {
      dotenv.env['IMAGE_PREFIX'] = '';
      await tester.pumpWidget(MaterialApp(home: MovieCardWidget(movie: movie)));

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(movieCardErrorIconKey), findsOneWidget);
    });

    testWidgets('Displays image prefix error when IMAGE_PREFIX is empty',
        (WidgetTester tester) async {
      dotenv.env['IMAGE_PREFIX'] = '';
      await tester.pumpWidget(MaterialApp(home: MovieCardWidget(movie: movie)));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byKey(movieCardErrorIconKey), findsOneWidget);
    });
  });
}
