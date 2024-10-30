import 'package:big_movie_app/models/movie_model.dart';
import 'package:equatable/equatable.dart';

abstract class ApiState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ApiInitialState extends ApiState {}

final class ApiLoadedState extends ApiState {
  ApiLoadedState({required this.movies, this.isFetchingMore = false});

  final List<Movie> movies;
  final bool isFetchingMore;

  @override
  List<Object?> get props => [movies, isFetchingMore];
}

final class ApiLoadingState extends ApiState {}

class ApiNoNetworkState extends ApiState {
  final String message;

  ApiNoNetworkState({this.message = "No Network Connection"});

  @override
  List<Object?> get props => [message];
}

final class ApiErrorState extends ApiState {
  ApiErrorState({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
