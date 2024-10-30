import 'package:big_movie_app/blocs/api_cubit.dart';
import 'package:big_movie_app/blocs/api_state.dart';
import 'package:big_movie_app/views/widgets/movie_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color backgroundColor = Colors.white;
  final double gridSpacing = 15.0;

  late ScrollController _scrollController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = BlocProvider.of<ApiCubit>(context).state;

      if (state is ApiLoadedState) {
        // Fetch more movies only if not already fetching
        setState(() {
          _currentPage++;
        });
        context
            .read<ApiCubit>()
            .fetchMoreMovies(existedMovies: state.movies, page: _currentPage);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiCubit, ApiState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          child: NestedScrollView(
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar.medium(
                  backgroundColor: backgroundColor,
                  expandedHeight: 20.0,
                  forceElevated: true,
                  floating: true,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      'Popular Movies',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildContent(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ApiState state) {
    if (state is ApiLoadedState) {
      final List<dynamic> movieList = List.from(state.movies);

      return GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: gridSpacing,
          mainAxisSpacing: gridSpacing,
          childAspectRatio: 2 / 3,
        ),
        itemCount: _getMovieList(state, movieList),
        itemBuilder: (context, index) {
          if (index < movieList.length) {
            return MovieCardWidget(
              movie: movieList[index],
            );
          } else {
            return const MovieCardWidget(movie: null);
          }
        },
      );
    } else if (state is ApiLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ApiErrorState) {
      return Scaffold(
        body: Center(
          child: Text("Error: ${state.errorMessage}"),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(child: Text("Welcome to Big Movie")),
      );
    }
  }

  int _getMovieList(ApiLoadedState state, List<dynamic> movieList) {
    int length = movieList.length;

    if (state.isFetchingMore) {
      int remainder = length % 3;

      if (remainder == 0) {
        return length + 3;
      } else if (remainder == 2) {
        return length + 1;
      } else {
        return length + 2;
      }
    }

    return length;
  }
}
