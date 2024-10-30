import 'package:big_movie_app/blocs/api_state.dart';
import 'package:big_movie_app/controls/api_controls.dart';
import 'package:big_movie_app/models/movie_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit(this.apiControls) : super(ApiInitialState()) {
    fetchMovies();
  }

  final ApiControls apiControls;

  Future<void> fetchMovies() async {
    try {
      emit(ApiLoadingState());
      final response = await apiControls.fetchPopularMovies();

      if (response.statusCode == 200) {
        List<Movie> movies = Movie.parseMovies(response.body);

        emit(ApiLoadedState(movies: movies));
      } else {
        emit(ApiErrorState(
            errorMessage:
                "Request failed with status: ${response.statusCode} : ${response.reasonPhrase}."));
      }
    } catch (e) {
      emit(ApiErrorState(errorMessage: "Error: $e"));
    }
  }

  Future<void> fetchMoreMovies(
      {required List<Movie> existedMovies, required int page}) async {
    try {
      emit(ApiLoadedState(movies: existedMovies, isFetchingMore: true));
      final response = await apiControls.fetchPopularMovies(page: page);

      if (response.statusCode == 200) {
        List<Movie> movies = Movie.parseMovies(response.body);
        existedMovies.addAll(movies);
        emit(ApiLoadedState(movies: existedMovies));
      } else {
        emit(ApiErrorState(
            errorMessage:
                "Request failed with status: ${response.statusCode} : ${response.reasonPhrase}."));
      }
    } catch (e) {
      emit(ApiErrorState(errorMessage: "Error: $e"));
    }
  }
}
