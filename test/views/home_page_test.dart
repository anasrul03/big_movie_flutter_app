import 'dart:convert';

import 'package:big_movie_app/blocs/api_cubit.dart';
import 'package:big_movie_app/blocs/api_state.dart';
import 'package:big_movie_app/controls/api_controls.dart';
import 'package:big_movie_app/keys/home_page_keys.dart';
import 'package:big_movie_app/keys/movie_card_keys.dart';
import 'package:big_movie_app/models/movie_model.dart';
import 'package:big_movie_app/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../di/generate_mocks.mocks.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  late ApiCubit apiCubit;
  late ApiControls apiControls;

  final mockMovieJson = jsonEncode({
    'results': List.generate(5, (index) {
      return {
        'adult': false,
        'backdrop_path': 'path/to/backdrop_$index.jpg',
        'genre_ids': [28, 12],
        'id': index,
        'original_language': 'en',
        'original_title': 'Original Title $index',
        'overview': 'Overview of movie $index',
        'popularity': 10.0 * index,
        'poster_path': 'path/to/image_$index.jpg',
        'release_date': '2024-01-01',
        'title': 'Movie Title $index',
        'video': false,
        'vote_average': 7.0 + index,
        'vote_count': 100 + index * 10,
      };
    }),
  });

  final movies = Movie.parseMovies(mockMovieJson);

  setUpAll(() {
    apiControls = MockApiControls();
    apiCubit = ApiCubit(apiControls);
    when(apiControls.fetchPopularMovies())
        .thenAnswer((_) async => Response(mockMovieJson, 200));
    when(apiControls.fetchPopularMovies(page: 2))
        .thenAnswer((_) async => Response(mockMovieJson, 200));
  });

  Widget buildHomePageWidget() {
    return MaterialApp(
      home: BlocProvider<ApiCubit>.value(
        value: apiCubit,
        child: const HomePage(),
      ),
    );
  }

  testWidgets('Displays Welcome to Big Movie when state is ApiInitialState',
      (WidgetTester tester) async {
    apiCubit.emit(ApiInitialState());

    await tester.pumpWidget(buildHomePageWidget());

    expect(find.byKey(welcomeWidgetKey), findsOneWidget);
  });

  testWidgets('Displays loading indicator when state is ApiLoadingState',
      (WidgetTester tester) async {
    apiCubit.emit(ApiLoadingState());

    await tester.pumpWidget(buildHomePageWidget());

    expect(find.byKey(loadingWidgetKey), findsOneWidget);
  });

  testWidgets('Displays error message when state is ApiErrorState',
      (WidgetTester tester) async {
    const errorMessage = "Network Error";
    apiCubit.emit(ApiErrorState(errorMessage: errorMessage));

    await tester.pumpWidget(buildHomePageWidget());

    expect(find.byKey(errorWidgetKey), findsOneWidget);
  });

  testWidgets('Displays movie list when state is ApiLoadedState',
      (WidgetTester tester) async {
    apiCubit.emit(ApiLoadedState(movies: movies));

    await tester.pumpWidget(buildHomePageWidget());

    expect(find.byKey(movieCardKey('0')), findsOneWidget);
    expect(find.byKey(movieCardKey('1')), findsOneWidget);
    expect(find.byKey(movieCardKey('2')), findsOneWidget);
    expect(find.byKey(movieCardKey('3')), findsOneWidget);
    expect(find.byKey(movieCardKey('4')), findsOneWidget);
  });

  testWidgets('Fetches more movies when scrolled to bottom',
      (WidgetTester tester) async {
    apiCubit.emit(ApiLoadedState(movies: movies, isFetchingMore: false));

    when(apiControls.fetchPopularMovies(page: 1))
        .thenAnswer((_) async => Response(mockMovieJson, 200));
    when(apiControls.fetchPopularMovies(page: 2))
        .thenAnswer((_) async => Response(mockMovieJson, 200));

    await tester.pumpWidget(buildHomePageWidget());

    verify(apiControls.fetchPopularMovies(page: 1)).called(1);

    await tester.drag(find.byType(GridView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    apiCubit
        .emit(ApiLoadedState(movies: movies + movies, isFetchingMore: false));
    await tester.pump();

    verify(apiControls.fetchPopularMovies(page: 2)).called(1);
  });
}
